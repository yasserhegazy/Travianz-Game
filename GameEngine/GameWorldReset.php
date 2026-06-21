<?php

class GameWorldReset
{
    private const PRESERVED_TABLES = ['winner_history'];
    private const SYSTEM_USER_IDS = [1, 2, 4, 5];

    public static function resetAfterWonderWinner(): bool
    {
        return self::reset(true);
    }

    public static function resetFromAdmin(): bool
    {
        return self::reset(true);
    }

    private static function reset(bool $preserveWinnerHistory): bool
    {
        global $database;

        @set_time_limit(0);

        if (!isset($database) || !isset($database->dblink)) {
            error_log('GameWorldReset: database connection is not available');
            return false;
        }

        $adminUsers = self::getAdminUsers();

        mysqli_query($database->dblink, 'SET FOREIGN_KEY_CHECKS=0');

        foreach (self::getGameTables() as $table) {
            if ($preserveWinnerHistory && self::shouldPreserveTable($table)) {
                continue;
            }

            if (!mysqli_query($database->dblink, 'DROP TABLE IF EXISTS `'.self::escapeIdentifier($table).'`')) {
                error_log('GameWorldReset: failed dropping '.$table.': '.mysqli_error($database->dblink));
                mysqli_query($database->dblink, 'SET FOREIGN_KEY_CHECKS=1');
                return false;
            }
        }

        mysqli_query($database->dblink, 'SET FOREIGN_KEY_CHECKS=1');

        if ($database->createDbStructure() !== true) {
            error_log('GameWorldReset: createDbStructure failed');
            return false;
        }

        if ($database->populateWorldData() !== true) {
            error_log('GameWorldReset: populateWorldData failed');
            return false;
        }

        if (!self::hasWorldData()) {
            error_log('GameWorldReset: populateWorldData finished without usable world data');
            return false;
        }

        if (method_exists($database, 'populateCroppers')) {
            $cropperResult = $database->populateCroppers(0, true);
            if (is_array($cropperResult) && empty($cropperResult['ok'])) {
                error_log('GameWorldReset: populateCroppers failed: '.($cropperResult['msg'] ?? 'unknown error'));
            }
        }

        self::restoreAdminUsers($adminUsers);
        self::ensureAdminVillages();
        if (!self::updateServerStartConfig()) {
            return false;
        }
        self::clearRuntimeFiles();

        return true;
    }

    private static function getGameTables(): array
    {
        global $database;

        $tables = [];
        $prefix = mysqli_real_escape_string($database->dblink, TB_PREFIX);
        $result = mysqli_query($database->dblink, "SHOW FULL TABLES LIKE '".$prefix."%'");

        if (!$result) {
            error_log('GameWorldReset: SHOW TABLES failed: '.mysqli_error($database->dblink));
            return $tables;
        }

        while ($row = mysqli_fetch_array($result, MYSQLI_NUM)) {
            if (isset($row[1]) && strtoupper($row[1]) !== 'BASE TABLE') {
                continue;
            }
            $tables[] = $row[0];
        }

        return $tables;
    }

    private static function shouldPreserveTable(string $table): bool
    {
        foreach (self::PRESERVED_TABLES as $tableName) {
            if ($table === TB_PREFIX.$tableName) {
                return true;
            }
        }

        return false;
    }

    private static function hasWorldData(): bool
    {
        global $database;

        $table = TB_PREFIX.'wdata';
        $result = mysqli_query(
            $database->dblink,
            'SELECT COUNT(*) AS total FROM `'.self::escapeIdentifier($table).'` WHERE fieldtype > 0'
        );

        if (!$result) {
            error_log('GameWorldReset: cannot verify world data: '.mysqli_error($database->dblink));
            return false;
        }

        $row = mysqli_fetch_assoc($result);
        return (int)($row['total'] ?? 0) > 0;
    }

    private static function getAdminUsers(): array
    {
        global $database;

        $table = TB_PREFIX.'users';
        $result = @mysqli_query(
            $database->dblink,
            'SELECT * FROM `'.self::escapeIdentifier($table).'` WHERE access >= 8'
        );

        if (!$result) {
            return [];
        }

        $users = [];
        while ($row = mysqli_fetch_assoc($result)) {
            if (in_array((int)$row['id'], self::SYSTEM_USER_IDS, true)) {
                continue;
            }
            $users[] = $row;
        }

        return $users;
    }

    private static function restoreAdminUsers(array $users): void
    {
        global $database;

        if (empty($users)) {
            return;
        }

        $table = TB_PREFIX.'users';
        $columnsResult = mysqli_query($database->dblink, 'SHOW COLUMNS FROM `'.self::escapeIdentifier($table).'`');
        if (!$columnsResult) {
            error_log('GameWorldReset: cannot inspect users table: '.mysqli_error($database->dblink));
            return;
        }

        $validColumns = [];
        while ($column = mysqli_fetch_assoc($columnsResult)) {
            $validColumns[$column['Field']] = true;
        }

        foreach ($users as $user) {
            $columns = [];
            $values = [];

            foreach ($user as $column => $value) {
                if (!isset($validColumns[$column])) {
                    continue;
                }

                $columns[] = '`'.self::escapeIdentifier($column).'`';
                $values[] = $value === null
                    ? 'NULL'
                    : "'".mysqli_real_escape_string($database->dblink, (string)$value)."'";
            }

            if (empty($columns)) {
                continue;
            }

            $sql = 'INSERT IGNORE INTO `'.self::escapeIdentifier($table).'` ('.implode(', ', $columns).') VALUES ('.implode(', ', $values).')';
            if (!mysqli_query($database->dblink, $sql)) {
                error_log('GameWorldReset: failed restoring admin user '.($user['id'] ?? '?').': '.mysqli_error($database->dblink));
            }
        }

        $maxIdResult = mysqli_query($database->dblink, 'SELECT COALESCE(MAX(id), 0) + 1 AS next_id FROM `'.self::escapeIdentifier($table).'`');
        if ($maxIdResult && ($row = mysqli_fetch_assoc($maxIdResult))) {
            mysqli_query($database->dblink, 'ALTER TABLE `'.self::escapeIdentifier($table).'` AUTO_INCREMENT = '.max(6, (int)$row['next_id']));
        }
    }

    private static function ensureAdminVillages(): void
    {
        global $database;

        $result = mysqli_query(
            $database->dblink,
            'SELECT id, username FROM `'.self::escapeIdentifier(TB_PREFIX.'users').'` WHERE access >= 8 ORDER BY id ASC'
        );

        if (!$result) {
            error_log('GameWorldReset: cannot load admin users for village restore: '.mysqli_error($database->dblink));
            return;
        }

        while ($user = mysqli_fetch_assoc($result)) {
            $uid = (int)$user['id'];
            $exists = mysqli_query(
                $database->dblink,
                'SELECT wref FROM `'.self::escapeIdentifier(TB_PREFIX.'vdata').'` WHERE owner = '.$uid.' LIMIT 1'
            );

            if ($exists && mysqli_num_rows($exists) > 0) {
                continue;
            }

            $wid = self::findFreeWorldTile();
            if ($wid <= 0) {
                error_log('GameWorldReset: no free world tile found for admin user '.$uid);
                continue;
            }

            $database->setFieldTaken($wid);
            $database->addVillage($wid, $uid, $user['username'], 1);
            $database->addResourceFields($wid, $database->getVillageType($wid, false));
            $database->addUnits($wid);
            $database->addTech($wid);
            $database->addABTech($wid);
        }
    }

    private static function findFreeWorldTile(): int
    {
        global $database;

        $table = TB_PREFIX.'wdata';
        $result = mysqli_query(
            $database->dblink,
            'SELECT id FROM `'.self::escapeIdentifier($table).'`
             WHERE occupied = 0 AND fieldtype > 0
             ORDER BY ABS(x), ABS(y), id
             LIMIT 1'
        );

        if (!$result || mysqli_num_rows($result) == 0) {
            return 0;
        }

        $row = mysqli_fetch_assoc($result);
        return (int)$row['id'];
    }

    private static function updateServerStartConfig(): bool
    {
        $configFile = __DIR__.'/config.php';
        if (!is_file($configFile) || !is_writable($configFile)) {
            error_log('GameWorldReset: config file is not writable: '.$configFile);
            return false;
        }

        $now = time();
        $config = file_get_contents($configFile);
        if ($config === false) {
            error_log('GameWorldReset: cannot read config file: '.$configFile);
            return false;
        }

        $config = preg_replace('/define\("COMMENCE","[^"]*"\);/', 'define("COMMENCE","'.$now.'");', $config);
        $config = preg_replace('/define\("START_DATE",\s*"[^"]*"\);/', 'define("START_DATE", "'.date('d.m.Y', $now).'");', $config);
        $config = preg_replace('/define\("START_TIME",\s*"[^"]*"\);/', 'define("START_TIME", "'.date('H:i', $now).'");', $config);

        if (file_put_contents($configFile, $config) === false) {
            error_log('GameWorldReset: cannot write config file: '.$configFile);
            return false;
        }

        return true;
    }

    private static function clearRuntimeFiles(): void
    {
        $base = dirname(__DIR__).'/';
        foreach (['automation.lck', 'Templates/text.tpl'] as $file) {
            $path = $base.$file;
            if (is_file($path)) {
                @unlink($path);
            }
        }

        $preventionDir = $base.'GameEngine/Prevention';
        if (is_dir($preventionDir)) {
            foreach (glob($preventionDir.'/*.txt') ?: [] as $file) {
                @unlink($file);
            }
        }
    }

    private static function escapeIdentifier(string $identifier): string
    {
        return str_replace('`', '``', $identifier);
    }
}
