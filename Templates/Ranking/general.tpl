<?php


function stat_countdown($targetTime) {
    $left = $targetTime - time();

    if ($left <= 0) {
        return 'ظهرت';
    }

    $days = floor($left / 86400);
    $hours = floor(($left % 86400) / 3600);
    $minutes = floor(($left % 3600) / 60);
    $seconds = $left % 60;

    return 'بعد '.$days.' يوم و '.$hours.' ساعة و '.$minutes.' دقيقة و '.$seconds.' ثانية';
}

function stat_end_countdown($targetTime) {
    $left = $targetTime - time();

    if ($left <= 0) {
        return 'انتهى';
    }

    $days = floor($left / 86400);
    $hours = floor(($left % 86400) / 3600);
    $minutes = floor(($left % 3600) / 60);
    $seconds = $left % 60;

    return 'بعد '.$days.' يوم '.$hours.' ساعة '.$minutes.' دقيقة '.$seconds.' ثانية';
}

$startTime = defined('START_DATE') ? strtotime(START_DATE) : time();
$serverAgeDays = max(0, floor((time() - $startTime) / 86400));

$artifactsTime = defined('NATARS_SPAWN_TIME') ? $startTime + (NATARS_SPAWN_TIME * 86400) : 0;
$plansTime = defined('NATARS_WW_BUILDING_PLAN_SPAWN_TIME') ? $startTime + (NATARS_WW_BUILDING_PLAN_SPAWN_TIME * 86400) : 0;
$wwTime = defined('NATARS_WW_SPAWN_TIME') ? $startTime + (NATARS_WW_SPAWN_TIME * 86400) : 0;
$serverEndTime = $startTime + (23 * 86400);

$serverWinner = null;

$winnerSql = mysqli_query($database->dblink, "
    SELECT vref 
    FROM ".TB_PREFIX."fdata 
    WHERE f99 = '100' AND f99t = '40' 
    LIMIT 1
");

if ($winnerSql && mysqli_num_rows($winnerSql) > 0) {
    $winnerRow = mysqli_fetch_assoc($winnerSql);
    $winnerVref = (int)$winnerRow['vref'];

    $winnerVillage = $database->getVillage($winnerVref);

    if ($winnerVillage && isset($winnerVillage['owner'])) {
        $winnerOwner = (int)$winnerVillage['owner'];

        $winnerUserSql = mysqli_query($database->dblink, "
            SELECT id, username, tribe 
            FROM ".TB_PREFIX."users 
            WHERE id = ".$winnerOwner." 
            LIMIT 1
        ");

        if ($winnerUserSql && mysqli_num_rows($winnerUserSql) > 0) {
            $serverWinner = mysqli_fetch_assoc($winnerUserSql);
        }
    }
}

$tribe1 = mysqli_fetch_assoc(mysqli_query($database->dblink, "SELECT COUNT(*) as Total FROM ".TB_PREFIX."users WHERE tribe = 1"));
$tribe2 = mysqli_fetch_assoc(mysqli_query($database->dblink, "SELECT COUNT(*) as Total FROM ".TB_PREFIX."users WHERE tribe = 2"));
$tribe3 = mysqli_fetch_assoc(mysqli_query($database->dblink, "SELECT COUNT(*) as Total FROM ".TB_PREFIX."users WHERE tribe = 3"));

$tribe4 = array('Total' => 0); // العرب مستقبلاً

$usersQuery = mysqli_fetch_assoc(mysqli_query($database->dblink, "SELECT COUNT(*) as Total FROM ".TB_PREFIX."users WHERE tribe > 0 AND tribe < 4"));
$users = (int)$usersQuery['Total'];

$onlineQuery = mysqli_fetch_assoc(mysqli_query($database->dblink, "SELECT COUNT(*) as Total FROM ".TB_PREFIX."users WHERE timestamp > ".(time() - 600)." AND tribe > 0 AND tribe < 4"));
$online = (int)$onlineQuery['Total'];

function tribe_percent($count, $total) {
    return ($total > 0) ? round(($count / $total) * 100, 2).'%' : '0%';
}
?>

<style>
.countdown-box span.num {
    font-weight: bold;
    color: #111;
}
.countdown-box span.txt {
    color: #555;
}
.tribe-title {
    font-weight: bold;
}
</style>

<script>
function updateStatCountdowns() {
    var items = document.querySelectorAll('[data-countdown]');

    items.forEach(function(el) {
        var target = parseInt(el.getAttribute('data-countdown'), 10);
        var now = Math.floor(Date.now() / 1000);
        var left = target - now;

        if (left <= 0) {
            var endedText = el.getAttribute('data-ended-text') || 'ظهرت';
el.innerHTML = '<span class="num">' + endedText + '</span>';
            return;
        }

        var days = Math.floor(left / 86400);
        var hours = Math.floor((left % 86400) / 3600);
        var minutes = Math.floor((left % 3600) / 60);
        var seconds = left % 60;

        el.innerHTML =
            '<span class="txt">بعد </span>' +
            '<span class="num">' + days + '</span> <span class="txt">يوم </span>' +
            '<span class="num">' + hours + '</span> <span class="txt">ساعة </span>' +
            '<span class="num">' + minutes + '</span> <span class="txt">دقيقة </span>' +
            '<span class="num">' + seconds + '</span> <span class="txt">ثانية</span>';
    });
}

setInterval(updateStatCountdowns, 1000);
window.addEventListener('load', updateStatCountdowns);
</script>

<table cellpadding="1" cellspacing="1" class="world">
    <thead>
        <tr>
            <th colspan="2">معلومات السيرفر</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>بدأ السيرفر منذ</td>
            <td><span style="font-weight:bold;"><?php echo $serverAgeDays; ?></span> يوم</td>
        </tr>
        <tr>
    <td>مدة السيرفر</td>
    <td><span style="font-weight:bold;">23</span> يوم</td>
</tr>
<tr>
    <td>ينتهي السيرفر</td>
    <td>
        <?php if ($serverWinner) { ?>
            انتهى، فاز 
            <a href="spieler.php?uid=<?php echo $serverWinner['id']; ?>">
                <?php echo $serverWinner['username']; ?>
            </a>
            بالسيرفر
        <?php } else { ?>
            <span class="countdown-box" data-countdown="<?php echo $serverEndTime; ?>" data-ended-text="انتهى">
                <?php echo stat_end_countdown($serverEndTime); ?>
            </span>
        <?php } ?>
    </td>
</tr>
            <td>ظهور التحف</td>
            <td class="countdown-box" data-countdown="<?php echo $artifactsTime; ?>"><?php echo $artifactsTime ? stat_countdown($artifactsTime) : 'غير محدد'; ?></td>
        </tr>
        <tr>
            <td>ظهور مخطوطات البناء</td>
            <td class="countdown-box" data-countdown="<?php echo $plansTime; ?>"><?php echo $plansTime ? stat_countdown($plansTime) : 'غير محدد'; ?></td>
        </tr>
        <tr>
            <td>ظهور قرى المعجزة</td>
            <td class="countdown-box" data-countdown="<?php echo $wwTime; ?>"><?php echo $wwTime ? stat_countdown($wwTime) : 'غير محدد'; ?></td>
        </tr>
        <tr>
            <td>حجم إنتاج الموارد</td>
            <td>x100</td>
        </tr>
        <tr>
            <td>سرعة الجيوش</td>
            <td>x10</td>
        </tr>
        <tr>
            <td>حجم المخازن</td>
            <td>x100</td>
        </tr>
        <tr>
            <td>حجم المخابئ</td>
            <td>x4000</td>
        </tr>
        <tr>
            <td>موت الجيوش بسبب نقص القمح</td>
            <td>لا تموت</td>
        </tr>
    </tbody>
</table>

<br />

<table cellpadding="1" cellspacing="1" class="world">
    <thead>
        <tr>
            <th colspan="2">اللاعبون</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>اللاعبون المسجلون</td>
            <td><?php echo number_format($users); ?></td>
        </tr>
        <tr>
            <td>اللاعبون المتصلون</td>
            <td><?php echo number_format($online); ?></td>
        </tr>
    </tbody>
</table>

<br />

<table cellpadding="1" cellspacing="1" class="world">
    <thead>
        <tr>
            <th colspan="4">القبائل</th>
        </tr>
        <tr>
    <td class="tribe-title" style="color:#8B0000;">الرومان</td>
    <td class="tribe-title" style="color:#006400;">الإغريق</td>
    <td class="tribe-title" style="color:#B8860B;">الجرمان</td>
    <td class="tribe-title" style="color:#00008B;">العرب</td>
</tr>
    </thead>
    <tbody>
        <tr>
            <td><?php echo number_format($tribe1['Total']); ?> لاعب</td>
            <td><?php echo number_format($tribe2['Total']); ?> لاعب</td>
            <td><?php echo number_format($tribe3['Total']); ?> لاعب</td>
            <td>0 لاعب</td>
        </tr>
        <tr>
            <td><?php echo tribe_percent($tribe1['Total'], $users); ?></td>
            <td><?php echo tribe_percent($tribe2['Total'], $users); ?></td>
            <td><?php echo tribe_percent($tribe3['Total'], $users); ?></td>
            <td>0%</td>
        </tr>
    </tbody>
</table>