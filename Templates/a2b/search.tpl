<?php
  if ( !empty( $form ) && $form->valuearray ) {
    if ( !empty( $form->valuearray['disabled'] ) ) {
      $disabled = $form->valuearray['disabled'];
    }

    if ( !empty( $form->valuearray['disabledr'] ) ) {
      $disabledr = $form->valuearray['disabledr'];
    }
  }
?><table id="coords" cellpadding="1" cellspacing="1">
<input type="hidden" name="disabledr" value="<?php echo (isset($disabledr) ? $disabledr : ''); ?>">
<input type="hidden" name="disabled" value="<?php echo (isset($disabled) ? $disabled : ''); ?>">
    <tbody><tr>
        <td class="sel">

            <label>
                <input class="radio" name="c" <?php if ( ( !isset($disabledr) || !$disabledr ) && ( !isset($checked) || !$checked ) ) {?> checked=checked <?php }?>value="2" type="radio" <?php echo (isset($disabledr) ? $disabledr : ''); ?>>
                <?php echo (defined('LANG') && LANG === 'ar') ? 'تعزيز' : 'Reinforcement'; ?>
            </label>
        </td>
        <td class="vil">
            <span><?php echo (defined('LANG') && LANG === 'ar') ? 'القرية:' : 'Village:'; ?></span>
             <input class="text" name="dname" value="<?php echo $form->getValue('dname');?>" maxlength="20" type="text" >
        </td>

    </tr>
    <tr>
        <td class="sel">
            <label>
                <input class="radio" name="c" value="3" type="radio" <?php echo (isset($disabled) ? $disabled : ''); ?>>
                <?php echo (defined('LANG') && LANG === 'ar') ? 'هجوم كامل' : 'Normal attack'; ?>
            </label>
        </td>
        <td class="or">

                    </td>
    </tr>
    <tr>
        <td class="sel">
            <label>
                <input class="radio" name="c" <?php
                  if ( ( isset($disabledr) && $disabledr ) && ( isset($disabled) && $disabled ) ) {
                    $checked = ' checked="checked"';
                  }
                  echo ( ( isset($checked) ? $checked : '' ) );
                ?> value="4" type="radio">
                <?php echo (defined('LANG') && LANG === 'ar') ? 'هجوم للنهب' : 'Raid'; ?>
            </label>
        </td>

<?php
if(isset($_GET['z'])){
$coor = $database->getCoor($_GET['z']);
}
else{
$coor['x']=$form->getValue("x");
$coor['y']=$form->getValue("y");
}
?>
        <td class="target">
    <span class="coordX"><?php echo (defined('LANG') && LANG == 'ar') ? 'X:' : 'x:'; ?></span>
    <input class="text coordXInput" name="x" value="<?php echo $coor['x']; ?>" maxlength="4" type="text">

    <span class="coordY"><?php echo (defined('LANG') && LANG == 'ar') ? 'Y:' : 'y:'; ?></span>
    <input class="text coordYInput" name="y" value="<?php echo $coor['y']; ?>" maxlength="4" type="text">
</td>
    </tr>
</tbody></table>

       <button value="ok" name="s1" id="btn_ok" class="trav_buttons" alt="OK" onclick="this.disabled=true;this.form.submit();" /> <?php echo (defined('LANG') && LANG === 'ar') ? 'إرسال' : 'Ok'; ?> </button>
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
</div>

