<?php
$serverFilter = isset($_GET['server']) ? (int)$_GET['server'] : 0;
$page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
$perPage = 20;
$offset = ($page - 1) * $perPage;

$where = "WHERE is_hidden = 0";
if($serverFilter >= 1 && $serverFilter <= 5) {
    $where .= " AND server_id = ".$serverFilter;
}

$countSql = mysqli_query($database->dblink, "
    SELECT COUNT(*) AS total
    FROM ".TB_PREFIX."winner_history
    $where
");
$countRow = mysqli_fetch_assoc($countSql);
$totalRows = (int)$countRow['total'];
$totalPages = max(1, ceil($totalRows / $perPage));

$result = mysqli_query($database->dblink, "
    SELECT server_id, winner_name, tribe_name, alliance_name, win_date
    FROM ".TB_PREFIX."winner_history
    $where
    ORDER BY win_date DESC, id DESC
    LIMIT $offset, $perPage
");
?>

<div style="text-align:center; margin-bottom:10px;">
    <a href="statistiken.php?id=100">الجميع</a>
    |
    <a href="statistiken.php?id=100&server=1">سيرفر 1</a>
    |
    <a href="statistiken.php?id=100&server=2">سيرفر 2</a>
    |
    <a href="statistiken.php?id=100&server=3">سيرفر 3</a>
    |
    <a href="statistiken.php?id=100&server=4">سيرفر 4</a>
    |
    <a href="statistiken.php?id=100&server=5">سيرفر 5</a>
</div>

<table cellpadding="1" cellspacing="1" class="row_table_data" style="width:100%;">
    <thead>
        <tr>
            <th colspan="5">سجل الفائزين</th>
        </tr>
        <tr>
    <td style="width:10%;">السيرفر</td>
    <td style="width:30%;">الفائز</td>
    <td style="width:15%;">القبيلة</td>
    <td style="width:12%;">التحالف</td>
    <td style="width:33%;">تاريخ الفوز</td>
</tr>
    </thead>
    <tbody>
        <?php if($result && mysqli_num_rows($result) > 0) { ?>
            <?php while($row = mysqli_fetch_assoc($result)) { ?>
                <tr>
                    <td><?php echo (int)$row['server_id']; ?></td>
                    <td><?php echo htmlspecialchars($row['winner_name'], ENT_QUOTES, 'UTF-8'); ?></td>
                    <td><?php echo htmlspecialchars($row['tribe_name'], ENT_QUOTES, 'UTF-8'); ?></td>
                    <td><?php echo htmlspecialchars($row['alliance_name'], ENT_QUOTES, 'UTF-8'); ?></td>
                    <td><span dir="ltr"><?php echo date('d-M-Y', (int)$row['win_date']); ?></span></td>
                </tr>
            <?php } ?>
        <?php } else { ?>
            <tr>
                <td colspan="5">لا توجد سجلات فوز حتى الآن</td>
            </tr>
        <?php } ?>
    </tbody>
</table>

<?php if($totalPages > 1) { ?>
    <div style="text-align:center; margin-top:10px;">
        <?php for($p = 1; $p <= $totalPages; $p++) { ?>
            <?php if($p == $page) { ?>
                <b><?php echo $p; ?></b>
            <?php } else { ?>
                <a href="statistiken.php?id=45<?php echo $serverFilter ? '&server='.$serverFilter : ''; ?>&page=<?php echo $p; ?>"><?php echo $p; ?></a>
            <?php } ?>
            <?php if($p < $totalPages) echo ' | '; ?>
        <?php } ?>
    </div>
<?php } ?>