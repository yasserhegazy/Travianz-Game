<h1><?php echo (defined('LANG') && LANG === 'ar') ? 'إرسال القوات' : 'Send Troops'; ?></h1>

<?php
if (!empty($form) && $form->valuearray) {
    if (!empty($form->valuearray['disabled'])) $disabled = $form->valuearray['disabled'];
    if (!empty($form->valuearray['disabledr'])) $disabledr = $form->valuearray['disabledr'];
}

if(isset($_GET['z'])){
    $coor = $database->getCoor($_GET['z']);
}else{
    $coor['x'] = $form->getValue("x");
    $coor['y'] = $form->getValue("y");
}
$prefillTargetId = isset($_GET['z']) ? (int)$_GET['z'] : 0;
$prefillOwnerId = 0;
$prefillOwnerName = '';
$prefillVillageName = '';
$prefillIsTarget = false;

if($prefillTargetId > 0){
    $q = $database->query("
        SELECT v.wref, v.name, v.owner, v.capital, u.username, w.x, w.y
        FROM ".TB_PREFIX."vdata v
        LEFT JOIN ".TB_PREFIX."users u ON u.id = v.owner
        LEFT JOIN ".TB_PREFIX."wdata w ON w.id = v.wref
        WHERE v.wref = ".$prefillTargetId."
        LIMIT 1
    ");

    if($q && mysqli_num_rows($q)){
        $r = mysqli_fetch_assoc($q);

        $prefillOwnerId = (int)$r['owner'];
        $prefillOwnerName = $r['username'];
        $prefillVillageName = $r['name'];

        if((int)$r['capital'] == 1){
            $prefillVillageName .= ' (العاصمة)';
        }

        $coor['x'] = (int)$r['x'];
        $coor['y'] = (int)$r['y'];
        $prefillIsTarget = true;
    }
}
if(!$prefillIsTarget && $database->isVillageOases($prefillTargetId)){
    $oasisOwnerVillage = (int)$database->getOasisField($prefillTargetId, "conqured");

    if($oasisOwnerVillage > 0){
        $prefillOwnerId = (int)$database->getVillageField($oasisOwnerVillage, "owner");
        $prefillOwnerName = $database->getUserField($prefillOwnerId, "username", 0);
        $prefillVillageName = 'واحة مملوكة';
    } else {
        $prefillOwnerId = 0;
        $prefillOwnerName = '';
        $prefillVillageName = 'واحة غير مملوكة';
    }

    $coor = $database->getCoor($prefillTargetId);
    $prefillIsTarget = true;
}
$unitStart = ($session->tribe - 1) * 10 + 1;
?>

<form method="POST" name="snd" action="a2b.php<?php echo isset($_GET['z']) ? '?s=2&z='.(int)$_GET['z'] : ''; ?>">
<input name="timestamp" value="1278280730" type="hidden">
<input name="timestamp_checksum" value="597fa8" type="hidden">
<input name="b" value="1" type="hidden">
<input type="hidden" name="disabledr" value="<?php echo (isset($disabledr) ? $disabledr : ''); ?>">
<input type="hidden" name="disabled" value="<?php echo (isset($disabled) ? $disabled : ''); ?>">

<table class="sendMainTable" cellpadding="1" cellspacing="1">
<tr>

<td class="sendSearchCell">
<table class="sendBoxTable" cellpadding="1" cellspacing="1">
<thead>
<tr><th colspan="2">الهدف</th></tr>
</thead>
<tbody>

<tr>
    <td class="sendLabel">المالك:</td>
    <td>
        <input type="hidden" name="owner_id" id="owner_id" value="<?php echo $prefillOwnerId; ?>">

<div id="ownerInputBox">
    <input class="text sendText" type="text" name="owner_name" id="owner_name" value="<?php echo htmlspecialchars($prefillOwnerName); ?>" maxlength="30">
    <div id="ownerSuggestions" class="targetSuggestions"></div>
</div>

<div id="ownerSelectedBox" style="display:none;">

    <span class="targetClearBtn"
          onclick="clearOwner()"
          title="حذف">✖</span>

    <a id="ownerSelectedLink"
       href="#"
       style="color:#6aa000;font-weight:bold;">
    </a>

</div>
    </td>
</tr>

<tr>
    <td class="sendLabel">القرية:</td>
    <td>
        <div id="villageInputBox">
            <input class="text sendText" name="dname" id="target_name"
                   value="<?php echo htmlspecialchars($prefillVillageName ? $prefillVillageName : $form->getValue('dname')); ?>"
                   maxlength="30" type="text">

            <select id="ownerVillagesSelect" class="text sendText" style="display:none;">
                <option value="">اختر القرية</option>
            </select>
        </div>

        <div id="villageSelectedBox" style="display:none;">
            <span class="targetClearBtn"
                  onclick="clearVillage()"
                  title="حذف">✖</span>

            <a id="villageSelectedLink"
               href="#"
               style="color:#6aa000;font-weight:bold;">
            </a>
        </div>
    </td>
</tr>

<tr>
    <td colspan="2" class="sendCoordsCell">
        <span class="coordX">X:</span>
        <input class="text coordXInput" name="x" id="target_x" value="<?php echo $coor['x']; ?>" maxlength="4" type="text">

        <span class="coordY">Y:</span>
        <input class="text coordYInput" name="y" id="target_y" value="<?php echo $coor['y']; ?>" maxlength="4" type="text">
    </td>
</tr>

<tr>
    <td colspan="2" class="sendCenter">
        <button type="button" class="trav_buttons" id="checkTargetBtn">تحقق</button>
    </td>
</tr>

</tbody>
</table>
<div id="targetCheckResult" style="text-align:center; margin-top:5px; font-weight:bold;"></div>
<table class="sendMissionTable" cellpadding="1" cellspacing="1">

<tr>
    <td id="mission2">
        <label>
            <input class="radio" name="c"
            <?php if((!isset($disabledr) || !$disabledr) && (!isset($checked) || !$checked)){ ?>
                checked="checked"
            <?php } ?>
            value="2" type="radio">
            تعزيز
        </label>
    </td>
</tr>

<tr>
    <td id="mission3">
        <label>
            <input class="radio" name="c"
            value="3" type="radio"
            <?php echo (isset($disabled) ? $disabled : ''); ?>>
            هجوم كامل
        </label>
    </td>
</tr>

<tr>
    <td id="mission4">
        <label>
            <input class="radio" name="c"
            <?php
            if((isset($disabledr) && $disabledr) && (isset($disabled) && $disabled)){
                echo 'checked="checked"';
            }
            ?>
            value="4" type="radio">
            هجوم للنهب
        </label>
    </td>
</tr>

</table>

<script>
function updateMissionColors() {

    document.getElementById('mission2').className = '';
    document.getElementById('mission3').className = '';
    document.getElementById('mission4').className = '';

    var selected = document.querySelector('input[name="c"]:checked');

    if(!selected) return;

    switch(selected.value) {

        case '2':
            document.getElementById('mission2').className = 'activeReinforce';
        break;

        case '3':
            document.getElementById('mission3').className = 'activeAttack';
        break;

        case '4':
            document.getElementById('mission4').className = 'activeRaid';
        break;
    }
}

document.addEventListener('DOMContentLoaded', function() {

    var radios = document.querySelectorAll('input[name="c"]');

    for(var i = 0; i < radios.length; i++) {
        radios[i].addEventListener('change', updateMissionColors);
    }

    updateMissionColors();
});
</script>

<td class="sendUnitsCell">
<table class="sendBoxTable sendUnitsTable" cellpadding="1" cellspacing="1">
<thead>
<tr>
    <th>القوات</th>
    <th><a href="#" onclick="sendAllTroops(); return false;">الكل</a></th>
</tr>
</thead>
<tbody>
<?php for($i = 1; $i <= 10; $i++):
    $unitId = $unitStart + ($i - 1);
    $unitKey = 'u'.$unitId;
    $inputName = 't'.$i;
    $amount = isset($village->unitarray[$unitKey]) ? (int)$village->unitarray[$unitKey] : 0;
?>
<tr>
    <td class="sendUnitInput">
        <img class="unit u<?php echo $unitId; ?>" src="img/x.gif" title="<?php echo constant('U'.$unitId); ?>" alt="<?php echo constant('U'.$unitId); ?>">
        <input class="text sendTroopInput" name="<?php echo $inputName; ?>" value="" maxlength="6" type="text" <?php if($amount <= 0) echo 'disabled="disabled"'; ?>>
    </td>
    <td class="sendAllCell">
        <?php if($amount > 0): ?>
            <a href="#" onclick="document.snd.<?php echo $inputName; ?>.value=<?php echo $amount; ?>; return false;"><?php echo number_format($amount); ?></a>
        <?php else: ?>
            <span class="none">0</span>
        <?php endif; ?>
    </td>
</tr>
<?php endfor; ?>

<?php if(isset($village->unitarray['hero']) && $village->unitarray['hero'] > 0): ?>
<tr>
    <td class="sendUnitInput">
        <img class="unit uhero" src="img/x.gif" title="البطل" alt="البطل">
        <input class="text sendTroopInput" name="t11" value="" maxlength="6" type="text">
    </td>
    <td class="sendAllCell">
        <a href="#" onclick="document.snd.t11.value=<?php echo (int)$village->unitarray['hero']; ?>; return false;"><?php echo number_format($village->unitarray['hero']); ?></a>
    </td>
</tr>
<?php endif; ?>
</tbody>
</table>
</td>

</tr>
</table>

<div class="sendButtonBox">
    <button value="ok" name="s1" id="btn_ok" class="trav_buttons" alt="OK" onclick="this.disabled=true;this.form.submit();">
        إرسال
    </button>
</div>

</form>

<p class="error" style="color:#c00000; font-weight:bold;">
    <?php echo $form->getError("error"); ?>
	<?php
$showRemoveProtectionBox = false;

if($database->hasBeginnerProtection($village->wid)) {
    $targetId = 0;

    if(isset($_GET['z'])) {
        $targetId = (int)$_GET['z'];
    } elseif(isset($_GET['d'])) {
        $targetId = (int)$_GET['d'];
    }

    if($targetId > 0) {
        $isOasisTarget = $database->isVillageOases($targetId);

        if(!$isOasisTarget) {
            $targetOwner = (int)$database->getVillageField($targetId, "owner");

            if($targetOwner > 0 && $targetOwner != (int)$session->uid) {
                $showRemoveProtectionBox = true;
            }
        } else {
            $oasisConquered = (int)$database->getOasisField($targetId, "conqured");

            if($oasisConquered > 0) {
                $oasisOwner = (int)$database->getVillageField($oasisConquered, "owner");

                if($oasisOwner > 0 && $oasisOwner != (int)$session->uid) {
                    $showRemoveProtectionBox = true;
                }
            }
        }
    }
}
?>
<?php
$errorMsg = $form->getError("error");

if(
    $database->hasBeginnerProtection($village->wid)
    && (
        strpos($errorMsg, 'الحماية') !== false
        || strpos($errorMsg, 'protection') !== false
    )
) {
    $showRemoveProtectionBox = true;
}
?>
    <?php if($showRemoveProtectionBox) { ?>
<div id="removeProtectionBox" style="text-align:center; margin:12px 0; font-weight:bold;">
    <div style="color:#c00000;">
        يجب إزالة الحماية أولاَ.
    </div>

    <input type="password" id="removeProtectPassword" placeholder="كلمة المرور" style="width:130px;">
    <button type="button" onclick="removeProtectionInline()">إزالة الحماية</button>

    <div id="removeProtectResult" style="margin-top:8px;"></div>
</div>

<script>
function removeProtectionInline() {
    var pass = document.getElementById('removeProtectPassword').value;
    var result = document.getElementById('removeProtectResult');

    if (!pass) {
        result.style.color = '#c00000';
        result.innerHTML = 'اكتب كلمة المرور أولاً.';
        return;
    }

    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'ajax_remove_protection.php', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onload = function() {
        if (xhr.responseText.trim() === 'OK') {
            result.style.color = '#008000';
            result.innerHTML = 'تمت إزالة الحماية، يمكنك الآن الهجوم.';
            document.getElementById('removeProtectionBox').innerHTML =
'✅ تمت إزالة الحماية، يمكنك الآن الهجوم.';
        } else {
            result.style.color = '#c00000';
            result.innerHTML = xhr.responseText;
        }
    };

    xhr.send('password=' + encodeURIComponent(pass));
}
</script>
<?php } ?>
</p>

<script>
function sendAllTroops() {
    <?php for($i = 1; $i <= 10; $i++):
        $unitId = $unitStart + ($i - 1);
        $unitKey = 'u'.$unitId;
        $amount = isset($village->unitarray[$unitKey]) ? (int)$village->unitarray[$unitKey] : 0;
        if($amount > 0):
    ?>
    if(document.snd.t<?php echo $i; ?>) document.snd.t<?php echo $i; ?>.value = <?php echo $amount; ?>;
    <?php endif; endfor; ?>

    <?php if(isset($village->unitarray['hero']) && $village->unitarray['hero'] > 0): ?>
    if(document.snd.t11) document.snd.t11.value = <?php echo (int)$village->unitarray['hero']; ?>;
    <?php endif; ?>
}
</script>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {

    var btn = document.getElementById('checkTargetBtn');
    if (!btn) return;

    btn.onclick = function () {

        var x = document.getElementById('target_x').value;
        var y = document.getElementById('target_y').value;
        var result = document.getElementById('targetCheckResult');

        result.style.color = '#666';
        result.innerHTML = 'جاري التحقق...';

        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'ajax_check_target.php', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

        xhr.onload = function () {
            try {
                var data = JSON.parse(xhr.responseText);

                if (data.status == 'ok') {

    if (data.type == 'village') {
        selectOwner(data.owner_id, data.owner);
        selectVillage(data.id, data.village, x, y);
		document.getElementById('villageSelectedLink').href = data.url;
    }

    if (data.type == 'oasis') {
        if (data.owner_id && data.owner_id > 0) {
            selectOwner(data.owner_id, data.owner);
        } else {
            clearOwner();
            document.getElementById('ownerInputBox').style.display = 'none';
            document.getElementById('ownerSelectedBox').style.display = 'none';
        }

        document.getElementById('target_name').value = data.village;
        document.getElementById('target_x').value = x;
        document.getElementById('target_y').value = y;

        document.getElementById('target_x').readOnly = true;
        document.getElementById('target_y').readOnly = true;

        document.getElementById('villageInputBox').style.display = 'none';
        document.getElementById('villageSelectedBox').style.display = 'block';

        document.getElementById('villageSelectedLink').innerHTML = data.village;
        document.getElementById('villageSelectedLink').href = data.url;
    }

    result.style.color = '#008000';
    result.innerHTML = '✓ تم العثور على الهدف';

} else {
                    result.style.color = '#c00000';
                    result.innerHTML = data.message;
                }

            } catch (e) {
                result.style.color = '#c00000';
                result.innerHTML = xhr.responseText;
            }
        };

        xhr.send(
            'x=' + encodeURIComponent(x) +
            '&y=' + encodeURIComponent(y)
        );
    };

});
</script>
<script>
function loadOwnerVillages(ownerId) {
    var select = document.getElementById('ownerVillagesSelect');
    var input = document.getElementById('target_name');

    if(!select) return;

    select.innerHTML = '<option value="">اختر القرية</option>';

    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'ajax_get_owner_villages.php', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onload = function() {
        try {
            var data = JSON.parse(xhr.responseText);

            for(var i = 0; i < data.length; i++){
                select.innerHTML +=
                    '<option value="' + data[i].id + '" data-x="' + data[i].x + '" data-y="' + data[i].y + '">' +
                    data[i].name +
                    '</option>';
            }

            input.style.display = 'none';
            select.style.display = 'inline-block';

        } catch(e) {}
    };

    xhr.send('owner_id=' + encodeURIComponent(ownerId));
}

function selectVillage(villageId, villageName, x, y){

    document.getElementById('target_name').value = villageName;
    document.getElementById('target_x').value = x;
    document.getElementById('target_y').value = y;

    document.getElementById('target_x').readOnly = true;
    document.getElementById('target_y').readOnly = true;

    document.getElementById('villageInputBox').style.display = 'none';
    document.getElementById('villageSelectedBox').style.display = 'block';

    var link = document.getElementById('villageSelectedLink');
    link.innerHTML = villageName;
    link.href = '#';
}

function clearVillage() {

    var ownerId = document.getElementById('owner_id').value;

    document.getElementById('target_name').value = '';
    document.getElementById('target_x').value = '';
    document.getElementById('target_y').value = '';

    document.getElementById('target_x').readOnly = false;
    document.getElementById('target_y').readOnly = false;
    document.getElementById('target_name').readOnly = false;

    document.getElementById('villageSelectedBox').style.display = 'none';
    document.getElementById('villageInputBox').style.display = 'block';

    if (ownerId != '') {
        document.getElementById('target_name').style.display = 'none';
        document.getElementById('ownerVillagesSelect').style.display = 'inline-block';
        document.getElementById('ownerVillagesSelect').value = '';
    } else {
        document.getElementById('ownerInputBox').style.display = 'block';
        document.getElementById('ownerSelectedBox').style.display = 'none';

        document.getElementById('owner_name').value = '';
        document.getElementById('owner_id').value = '';

        document.getElementById('target_name').style.display = 'inline-block';
        document.getElementById('ownerVillagesSelect').style.display = 'none';
        document.getElementById('ownerVillagesSelect').innerHTML = '<option value="">اختر القرية</option>';
    }
}
function selectOwner(ownerId, ownerName) {
    document.getElementById('owner_id').value = ownerId;
    document.getElementById('owner_name').value = ownerName;

    document.getElementById('ownerInputBox').style.display = 'none';
    document.getElementById('ownerSelectedBox').style.display = 'block';

    var link = document.getElementById('ownerSelectedLink');
    link.innerHTML = ownerName;
    link.href = 'spieler.php?uid=' + ownerId;
	loadOwnerVillages(ownerId);
}

function clearOwner() {
    document.getElementById('owner_id').value = '';
    document.getElementById('owner_name').value = '';

    document.getElementById('ownerInputBox').style.display = 'block';
    document.getElementById('ownerSelectedBox').style.display = 'none';

    document.getElementById('ownerSuggestions').style.display = 'none';
    document.getElementById('ownerSuggestions').innerHTML = '';
document.getElementById('ownerInputBox').style.display = 'block';
document.getElementById('target_name').readOnly = false;
    clearVillage();

    var select = document.getElementById('ownerVillagesSelect');
    select.innerHTML = '<option value="">اختر القرية</option>';
    select.style.display = 'none';

    document.getElementById('target_name').style.display = 'inline-block';
}
document.addEventListener('DOMContentLoaded', function () {

    var ownerInput = document.getElementById('owner_name');
    var box = document.getElementById('ownerSuggestions');
var villageSelect =
    document.getElementById('ownerVillagesSelect');

if(villageSelect){

    villageSelect.onchange = function(){

        if(!this.value) return;

        var opt =
            this.options[this.selectedIndex];

        selectVillage(
            this.value,
            opt.text,
            opt.getAttribute('data-x'),
            opt.getAttribute('data-y')
        );

    };

}
    if(!ownerInput || !box) return;

    ownerInput.onkeyup = function () {

        var q = ownerInput.value;

        if(q.length < 2){
            box.style.display = 'none';
            box.innerHTML = '';
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'ajax_search_owner.php', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

        xhr.onload = function () {
            try {
                var data = JSON.parse(xhr.responseText);

                if(!data.length){
                    box.style.display = 'none';
                    box.innerHTML = '';
                    return;
                }

                var html = '';

                for(var i = 0; i < data.length; i++){
                    html += '<div class="targetSuggestionItem" data-id="' + data[i].id + '" data-name="' + data[i].name + '">' + data[i].name + '</div>';
                }

                box.innerHTML = html;
                box.style.display = 'block';

                var items = box.getElementsByClassName('targetSuggestionItem');

                for(var j = 0; j < items.length; j++){
                    items[j].onclick = function () {
                        selectOwner(
    this.getAttribute('data-id'),
    this.getAttribute('data-name')
);

box.style.display = 'none';
                    };
                }

            } catch(e) {
                box.style.display = 'none';
            }
        };

        xhr.send('q=' + encodeURIComponent(q));
    };
<?php if($prefillIsTarget){ ?>
<?php if($prefillOwnerId > 0){ ?>
selectOwner('<?php echo $prefillOwnerId; ?>', '<?php echo addslashes($prefillOwnerName); ?>');
<?php } else { ?>
clearOwner();
document.getElementById('ownerInputBox').style.display = 'none';
document.getElementById('ownerSelectedBox').style.display = 'none';
<?php } ?>

selectVillage(
    '<?php echo $prefillTargetId; ?>',
    '<?php echo addslashes($prefillVillageName); ?>',
    '<?php echo (int)$coor['x']; ?>',
    '<?php echo (int)$coor['y']; ?>'
);

document.getElementById('villageSelectedLink').href =
    'karte.php?d=<?php echo $prefillTargetId; ?>&c=<?php echo $generator->getMapCheck($prefillTargetId); ?>';
<?php } ?>
});
</script>