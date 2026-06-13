<div id="build" class="gid17"><a href="#" onClick="return Popup(17,4);" class="build_logo"> 
	<img class="building g17" src="img/x.gif" alt="Marketplace" title="<?php echo MARKETPLACE;?>" /> 
</a> 
<h1><?php echo MARKETPLACE;?> <span class="level"><?php echo LEVEL;?> <?php echo $village->resarray['f'.$id]; ?></span></h1> 
<p class="build_desc"><?php echo MARKETPLACE_DESC;?>
</p> 
 
<?php include("17_menu.tpl"); ?>

<script language="JavaScript"> 
<!--
var haendler = <?php echo $market->merchantAvail(); ?>;
var carry = <?php echo $market->maxcarry; ?>;
//-->
</script>
<?php
for ($a = 1; $a <= 4; $a++) {
    if (!isset($_POST['r'.$a])) {
        $_POST['r'.$a] = 0;
    }
}
$allres = (int) $_POST['r1'] + (int) $_POST['r2'] + (int) $_POST['r3'] + (int) $_POST['r4'];
if(isset( $_POST['x'] ) && isset( $_POST['y'] ) && $_POST['x'] != "" && $_POST['y'] != "" && is_numeric($_POST['x']) && is_numeric($_POST['y'])){
	$getwref = $database->getVilWref($_POST['x'],$_POST['y']);
	$checkexist = $database->checkVilExist($getwref);
}
else if(!empty($_POST['dname'])){
	$getwref = $database->getVillageByName($_POST['dname']);
	$checkexist = $database->checkVilExist($getwref);
}
if(isset($checkexist) && $checkexist){
$villageOwner = $database->getVillageField($getwref,'owner');
$userAccess = $database->getUserField($villageOwner,'access',0);
$userVacation = $database->getUserField($villageOwner,'vac_mode',0);
$userID = $database->getUserField($villageOwner,'id',0);
}
$maxcarry = $market->maxcarry;
$maxcarry *= $market->merchantAvail();
if(isset($_POST['ft'])=='check' && (($_POST['send3'] > 1 && $_POST['send3'] <= 5 && $session->goldclub) || $_POST['send3'] == 1) && $getwref != $village->wid && $allres!=0 && $allres <= $maxcarry && ($_POST['x']!="" && $_POST['y']!="" or $_POST['dname']!="") && $checkexist && ($userAccess == 2 || $userAccess == MULTIHUNTER || (ADMIN_ALLOW_INCOMING_RAIDS && $userAccess == ADMIN)) && $userVacation == 0){
?>
<form method="POST" name="snd" action="build.php"> 
<input type="hidden" name="ft" value="mk1">
<input type="hidden" name="id" value="<?php echo $id; ?>">
<input type="hidden" name="send3" value="<?php echo $_POST['send3']; ?>">
<table id="send_select" class="send_res" cellpadding="1" cellspacing="1">
	<tr>
		<td class="ico"><img class="r1" src="img/x.gif" alt="Lumber" title="<?php echo LUMBER;?>" /></td> 
		<td class="nam"> <?php echo LUMBER;?></td> 
		<td class="val"><input class="text disabled" type="text" name="r1" id="r1" value="<?php echo $_POST['r1']; ?>" readonly="readonly"></td> 
		<td class="max"> / <span class="none"><B><?php echo $market->maxcarry; ?></B></span> </td> 
	</tr>
    <tr> 
		<td class="ico"><img class="r2" src="img/x.gif" alt="Clay" title="<?php echo CLAY;?>" /></td> 
		<td class="nam"> <?php echo CLAY;?></td> 
		<td class="val"><input class="text disabled" type="text" name="r2" id="r2" value="<?php echo $_POST['r2']; ?>" readonly="readonly"></td> 
		<td class="max"> / <span class="none"><b><?php echo$market->maxcarry; ?></b></span> </td> 
	</tr>
    <tr> 
		<td class="ico"><img class="r3" src="img/x.gif" alt="Iron" title="<?php echo IRON;?>" /></td> 
		<td class="nam"> <?php echo IRON;?></td> 
		<td class="val"><input class="text disabled" type="text" name="r3" id="r3" value="<?php echo $_POST['r3']; ?>" readonly="readonly"> 
		</td> 
		<td class="max"> / <span class="none"><b><?php echo $market->maxcarry; ?></b></span> </td> 
	</tr>
    <tr> 
		<td class="ico"><img class="r4" src="img/x.gif" alt="Crop" title="<?php echo CROP;?>" /></td> 
		<td class="nam"> <?php echo CROP;?></td> 
		<td class="val"> <input class="text disabled" type="text" name="r4" id="r4" value="<?php echo $_POST['r4']; ?>" readonly="readonly"> 
		</td> 
		<td class="max"> / <span class="none"><B><?php echo $market->maxcarry; ?></B></span></td> 
	</tr></table> 
<table id="target_validate" class="res_target" cellpadding="1" cellspacing="1">
	<tbody><tr>
		<th><?php echo COORDINATES;?>:</th>
        <?php
		if($_POST['x'] != "" && $_POST['y'] != "" && is_numeric($_POST['x']) && is_numeric($_POST['y'])){
          $getwref = $database->getVilWref($_POST['x'],$_POST['y']);
		  $getvilname = $database->getVillageField($getwref, "name");
		  $getvilowner = $database->getVillageField($getwref, "owner");
		  $getvilcoor['y'] = $_POST['y'];
		  $getvilcoor['x'] = $_POST['x'];
		  $time = $generator->procDistanceTime($getvilcoor, $village->coor, $session->tribe, 0);
		}
		else if(!empty($_POST['dname'])){
		  $getwref = $database->getVillageByName($_POST['dname']);
		  $getvilcoor = $database->getCoor($getwref);
		  $getvilname = $database->getVillageField($getwref, "name");
		  $getvilowner = $database->getVillageField($getwref, "owner");
		  $time = $generator->procDistanceTime($getvilcoor, $village->coor, $session->tribe, 0);
		}
        ?>
		<td><a href="karte.php?d=<?php echo $getwref; ?>&c=<?php echo $generator->getMapCheck($getwref); ?>"><?php echo $getvilname; ?>(<?php echo $getvilcoor['x']; ?>|<?php echo $getvilcoor['y']; ?>)<span class="clear"></span></a></td>
	</tr>
	<tr>
		<th><?php echo PLAYER;?>:</th>
		<td><a href="spieler.php?uid=<?php echo $getvilowner; ?>"><?php echo $database->getUserField($getvilowner,'username',0); ?></a></td>
	</tr>
	<tr>
		<th><?php echo DURATION;?>:</th>
		<td><?php echo $generator->getTimeFormat($time); ?></td>
	</tr>
	<tr>
		<th><?php echo MERCHANT;?>:</th>
		<td><?php
        $resource = array($_POST['r1'],$_POST['r2'],$_POST['r3'],$_POST['r4']); 
        echo ceil((array_sum($resource)-0.1)/$market->maxcarry); ?></td>
	</tr>

	<tr>
		<td colspan="2">
					</td>
	</tr>

</tbody></table>
<input type="hidden" name="getwref" value="<?php echo $getwref; ?>">
<div class="clear"></div>
<p>
<div class="clear"></div><p><input type="image" value="ok" name="s1" id="btn_ok" class="dynamic_img" src="img/x.gif" tabindex="8" alt="OK" <?php if(!$market->merchantAvail()) { echo "DISABLED"; }?>/></p></form>
<?php }else{ ?>
<form method="POST" name="snd" action="build.php">
<input type="hidden" name="ft" value="check">
<input type="hidden" name="id" value="<?php echo $id; ?>">

<table class="sendBoxTable marketMainTable" cellpadding="1" cellspacing="1">
    <tr>
        <th class="marketSearchHead">البحث</th>
        <th class="marketResourceHead">الموارد</th>
    </tr>

    <tr>
        <td class="marketSearchSide">

            <table class="marketInnerTable" cellpadding="1" cellspacing="1">
                <tr>
                    <td class="sendLabel">قراي:</td>
                    <td>
                        <a href="#" id="myVillagesBtn" onclick="marketToggleMyVillages(); return false;">اختيار</a>

                        <div id="myVillagesSelectBox" style="display:none; margin-top:5px;">
                            <select id="myVillagesSelect" onchange="marketUseMyVillage(this);">
                                <option value="">اختر القرية</option>
                                <?php
                                $myVillages = $database->getProfileVillages($session->uid);
                                if(is_array($myVillages)){
                                    foreach($myVillages as $myVillage){
                                        $myWref = isset($myVillage['wref']) ? (int)$myVillage['wref'] : 0;
                                        $myName = isset($myVillage['name']) ? $myVillage['name'] : '';
                                        $myCoor = $database->getCoor($myWref);

                                        echo '<option value="'.$myWref.'" data-name="'.htmlspecialchars($myName, ENT_QUOTES, 'UTF-8').'" data-x="'.$myCoor['x'].'" data-y="'.$myCoor['y'].'">'.htmlspecialchars($myName, ENT_QUOTES, 'UTF-8').'</option>';
                                    }
                                }
                                ?>
                            </select>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td class="sendLabel">اللاعب:</td>
                    <td>
                        <input class="text marketSearchInput" type="text" id="marketOwner" autocomplete="off">
                        <input type="hidden" id="marketOwnerId" value="">
                        <div id="marketOwnerSuggestions" class="targetSuggestions"></div>
                    </td>
                </tr>

                <tr>
                    <td class="sendLabel">القرية:</td>
                    <td>
                        <input class="text marketSearchInput" type="text" name="dname" id="marketDname" value="" maxlength="30" autocomplete="off">
                        <select id="marketVillageSelect" style="display:none;" onchange="marketUseOwnerVillage(this);"></select>
                    </td>
                </tr>

                <?php
                if(isset($_GET['z'])){
                    $coor = $database->getCoor($_GET['z']);
                }else{
                    $coor['x'] = "";
                    $coor['y'] = "";
                }
                ?>

                <tr>
                    <td colspan="2" class="sendCoordsCell">
                        <span class="coordX">X:</span>
                        <input class="text sendCoord coordXInput" type="text" name="x" id="marketX" value="<?php echo $coor['x']; ?>" maxlength="4">

                        <span class="coordY">Y:</span>
                        <input class="text sendCoord coordYInput" type="text" name="y" id="marketY" value="<?php echo $coor['y']; ?>" maxlength="4">
                    </td>
                </tr>

                <tr>
                    <td colspan="2" class="sendCenter">
                        <button type="submit" class="trav_buttons">تحقق</button>
                    </td>
                </tr>
            </table>

        </td>

        <td class="marketResourceSide">

            <table class="marketInnerTable marketResTable" cellpadding="1" cellspacing="1">
                <tr>
                    <td colspan="3" class="sendCenter">
                        التجار <?php echo $market->merchantAvail(); ?>/<?php echo $market->merchant; ?>
                        |
                        المتاح للنقل: <b id="marketRemainCarry">0</b>
                        |
                        التجار: <b id="marketUsedMerchants">0</b>
                    </td>
                </tr>

                <tr>
                    <td class="ico"><img class="r1" src="img/x.gif"></td>
                    <td class="val"><input class="text marketResInput" type="text" name="r1" id="r1" value="" maxlength="15" onKeyUp="upd_res(1); marketCalcResources();"></td>
                    <td class="max"><a href="#" onclick="add_res(1); setTimeout(marketCalcResources,20); return false;"><?php echo $market->maxcarry; ?></a></td>
                </tr>

                <tr>
                    <td class="ico"><img class="r2" src="img/x.gif"></td>
                    <td class="val"><input class="text marketResInput" type="text" name="r2" id="r2" value="" maxlength="15" onKeyUp="upd_res(2); marketCalcResources();"></td>
                    <td class="max"><a href="#" onclick="add_res(2); setTimeout(marketCalcResources,20); return false;"><?php echo $market->maxcarry; ?></a></td>
                </tr>

                <tr>
                    <td class="ico"><img class="r3" src="img/x.gif"></td>
                    <td class="val"><input class="text marketResInput" type="text" name="r3" id="r3" value="" maxlength="15" onKeyUp="upd_res(3); marketCalcResources();"></td>
                    <td class="max"><a href="#" onclick="add_res(3); setTimeout(marketCalcResources,20); return false;"><?php echo $market->maxcarry; ?></a></td>
                </tr>

                <tr>
                    <td class="ico"><img class="r4" src="img/x.gif"></td>
                    <td class="val"><input class="text marketResInput" type="text" name="r4" id="r4" value="" maxlength="15" onKeyUp="upd_res(4); marketCalcResources();"></td>
                    <td class="max"><a href="#" onclick="add_res(4); setTimeout(marketCalcResources,20); return false;"><?php echo $market->maxcarry; ?></a></td>
                </tr>

                <tr>
                    <td colspan="3" class="sendCenter">
                        عدد مرات النقل
                        <?php if($session->goldclub == 1){ ?>
                            <select name="send3" onchange="marketCalcResources();">
                                <option value="1" selected="selected">1x</option>
                                <option value="2">2x</option>
                                <option value="3">3x</option>
                                <option value="4">4x</option>
                                <option value="5">5x</option>
                            </select>
                        <?php }else{ ?>
                            <input type="hidden" name="send3" value="1">
                        <?php } ?>
                    </td>
                </tr>

                <tr>
                    <td colspan="3" class="sendCenter">
                        <input type="image" value="ok" name="s1" id="btn_ok" class="dynamic_img" src="img/x.gif" tabindex="8" alt="OK" <?php if(!$market->merchantAvail()) { echo "DISABLED"; }?>/>
                    </td>
                </tr>
            </table>

        </td>
    </tr>
</table>

<div class="clear"></div>
</form>

<script type="text/javascript">
function marketFormatNumber(n){
    n = parseInt(n || 0, 10);
    return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}
function marketGetInt(id){
    var el = document.getElementById(id);
    if(!el){ return 0; }
    var v = (el.value || '').replace(/,/g, '');
    v = parseInt(v, 10);
    return isNaN(v) ? 0 : v;
}
function marketCalcResources(){
    var merchants = parseInt(<?php echo (int)$market->merchantAvail(); ?>, 10) || 0;
    var carry = parseInt(<?php echo (int)$market->maxcarry; ?>, 10) || 0;
    var totalCarry = merchants * carry;
    var total = marketGetInt('r1') + marketGetInt('r2') + marketGetInt('r3') + marketGetInt('r4');
    var used = total > 0 ? Math.ceil(total / carry) : 0;
    var remain = totalCarry - total;
    var remainEl = document.getElementById('marketRemainCarry');
    var usedEl = document.getElementById('marketUsedMerchants');
    if(remainEl){ remainEl.innerHTML = marketFormatNumber(remain); remainEl.style.color = remain < 0 ? '#c00000' : '#4f8700'; }
    if(usedEl){ usedEl.innerHTML = marketFormatNumber(used); usedEl.style.color = used > merchants ? '#c00000' : '#4f8700'; }
}
function marketToggleMyVillages(){
    var box = document.getElementById('myVillagesSelectBox');
    if(box){ box.style.display = (box.style.display == 'none' || box.style.display == '') ? 'block' : 'none'; }
}
function marketUseMyVillage(sel){
    if(!sel || !sel.options || sel.selectedIndex < 0){ return; }
    var opt = sel.options[sel.selectedIndex];
    if(!opt || !opt.value){ return; }
    var owner = document.getElementById('marketOwner');
    var ownerId = document.getElementById('marketOwnerId');
    var dname = document.getElementById('marketDname');
    var villageSelect = document.getElementById('marketVillageSelect');
    var x = document.getElementById('marketX');
    var y = document.getElementById('marketY');
    if(owner){ owner.value = '<?php echo addslashes($database->getUserField($session->uid, 'username', 0)); ?>'; }
    if(ownerId){ ownerId.value = '<?php echo (int)$session->uid; ?>'; }
    if(villageSelect){ villageSelect.style.display = 'none'; }
    if(dname){ dname.style.display = ''; dname.value = opt.getAttribute('data-name') || ''; }
    if(x){ x.value = opt.getAttribute('data-x') || ''; }
    if(y){ y.value = opt.getAttribute('data-y') || ''; }
}
function marketUseOwnerVillage(sel){
    if(!sel || !sel.options || sel.selectedIndex < 0){ return; }
    var opt = sel.options[sel.selectedIndex];
    if(!opt || !opt.value){ return; }
    var dname = document.getElementById('marketDname');
    var x = document.getElementById('marketX');
    var y = document.getElementById('marketY');
    if(dname){ dname.value = opt.getAttribute('data-name') || opt.text; }
    if(x){ x.value = opt.getAttribute('data-x') || ''; }
    if(y){ y.value = opt.getAttribute('data-y') || ''; }
}
function marketAjax(url, data, cb){
    var xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
    xhr.onreadystatechange = function(){
        if(xhr.readyState === 4){ cb(xhr.responseText); }
    };
    xhr.send(data);
}
function marketOwnerSearch(q){
    var box = document.getElementById('marketOwnerSuggestions');
    if(!box){ return; }
    if(!q || q.length < 2){ box.style.display='none'; box.innerHTML=''; return; }
    marketAjax('ajax_search_owner.php', 'q=' + encodeURIComponent(q) + '&term=' + encodeURIComponent(q) + '&owner=' + encodeURIComponent(q), function(txt){
        var data = null;
        try{ data = JSON.parse(txt); }catch(e){ data = null; }
        box.innerHTML = '';
        if(data && data.status == 'ok' && data.results){ data = data.results; }
        if(data && data.length){
            for(var i=0;i<data.length;i++){
                var item = data[i];
                var id = item.id || item.uid || item.owner_id || '';
                var name = item.username || item.name || item.owner || '';
                var div = document.createElement('div');
                div.className = 'marketSuggestionItem';
                div.innerHTML = name;
                div.setAttribute('data-id', id);
                div.setAttribute('data-name', name);
                div.onclick = function(){ marketSelectOwner(this.getAttribute('data-id'), this.getAttribute('data-name')); };
                box.appendChild(div);
            }
            box.style.display = 'block';
        }else{
            box.style.display='none';
        }
    });
}
function marketSelectOwner(ownerId, ownerName){
    var owner = document.getElementById('marketOwner');
    var ownerHidden = document.getElementById('marketOwnerId');
    var box = document.getElementById('marketOwnerSuggestions');
    if(owner){ owner.value = ownerName || ''; }
    if(ownerHidden){ ownerHidden.value = ownerId || ''; }
    if(box){ box.style.display = 'none'; }
    marketLoadOwnerVillages(ownerId);
}
function marketLoadOwnerVillages(ownerId){
    var sel = document.getElementById('marketVillageSelect');
    var dname = document.getElementById('marketDname');
    if(!sel || !ownerId){ return; }
    marketAjax('ajax_get_owner_villages.php', 'owner_id=' + encodeURIComponent(ownerId) + '&uid=' + encodeURIComponent(ownerId), function(txt){
        var data = null;
        try{ data = JSON.parse(txt); }catch(e){ data = null; }
        if(data && data.status == 'ok' && data.villages){ data = data.villages; }
        sel.innerHTML = '<option value="">اختر القرية</option>';
        if(data && data.length){
            for(var i=0;i<data.length;i++){
                var v = data[i];
                var name = v.name || v.village || '';
                var x = v.x || v.coord_x || '';
                var y = v.y || v.coord_y || '';
                var cap = (v.capital == 1 || v.is_capital == 1) ? ' (العاصمة)' : '';
                var opt = document.createElement('option');
                opt.value = v.id || v.wref || name;
                opt.text = name + cap;
                opt.setAttribute('data-name', name);
                opt.setAttribute('data-x', x);
                opt.setAttribute('data-y', y);
                sel.appendChild(opt);
            }
            if(dname){ dname.style.display = 'none'; }
            sel.style.display = '';
        }else{
            sel.style.display = 'none';
            if(dname){ dname.style.display = ''; }
        }
    });
}
var marketOwnerTimer = null;
window.onload = function(){
    marketCalcResources();
    var owner = document.getElementById('marketOwner');
    if(owner){
        owner.onkeyup = function(){
            var q = this.value;
            clearTimeout(marketOwnerTimer);
            marketOwnerTimer = setTimeout(function(){ marketOwnerSearch(q); }, 180);
        };
    }
};
</script>

<?php
$error = '';
if(isset($_POST['ft'])=='check'){

    if($form->returnErrors() > 0) $error = '<span class="error"><b>'.$form->getError("error").'</b></span>';
    elseif(!$checkexist){
		$error = '<span class="error"><b>'.NO_COORDINATES_SELECTED.'</b></span>';
	}elseif($getwref == $village->wid){
		$error = '<span class="error"><b>'.CANNOT_SEND_RESOURCES.'</b></span>';
	}elseif($_POST['send3'] < 1 || $_POST['send3'] > 5 || ($_POST['send3'] > 1 && !$session->goldclub)){
	    $error = '<span class="error"><b>'.INVALID_MERCHANTS_REPETITION.'</b></span>';
	}elseif($userAccess == '0' or ($userAccess == MULTIHUNTER && $userID == 5) or (!ADMIN_ALLOW_INCOMING_RAIDS && $userAccess == ADMIN)){
		$error = '<span class="error"><b>'.BANNED_CANNOT_SEND_RESOURCES.'.</b></span>';
    }elseif($_POST['r1']==0 && $_POST['r2']==0 && $_POST['r3']==0 && $_POST['r4']==0){
		$error = '<span class="error"><b>'.RESOURCES_NO_SELECTED.'.</b></span>';
	}elseif($userVacation == '1') {
		$error = '<span class="error"><b>Player is on vacation mode. You cannot send resources to him.</b></span>';
    }elseif(!$_POST['x'] && !$_POST['y'] && !$_POST['dname']){
		$error = '<span class="error"><b>'.ENTER_COORDINATES.'.</b></span>';
    }elseif($allres > $maxcarry){
		$error = '<span class="error"><b>'.TOO_FEW_MERCHANTS.'.</b></span>';
    }
    echo $error;
}
?>
<p>
<?php } ?>
<p><?php echo MERCHANT_CARRY;?> <b><?php echo $market->maxcarry; ?></b> <?php echo UNITS_OF_RESOURCE;?> </p>
<?php
if(count($market->recieving) > 0) { 
echo "<h4>".MERCHANT_COMING.":</h4>";
    foreach($market->recieving as $recieve) {
       echo "<table class=\"traders\" cellpadding=\"1\" cellspacing=\"1\">";
	$villageowner = $database->getVillageField($recieve['from'],"owner");
	echo "<thead><tr><td><a href=\"spieler.php?uid=$villageowner\">".$database->getUserField($villageowner,"username",0)."</a></td>";
    echo "<td><a href=\"karte.php?d=".$recieve['from']."&c=".$generator->getMapCheck($recieve['from'])."\">".TRANSPORT_FROM." ".$database->getVillageField($recieve['from'],"name")."</a></td>";
    echo "</tr></thead><tbody><tr><th>".ARRIVAL_IN."</th><td>";
    echo "<div class=\"in\"><span id=timer".++$session->timer.">".$generator->getTimeFormat($recieve['endtime']-time())."</span> h</div>";
    $datetime = $generator->procMtime($recieve['endtime']);
    echo "<div class=\"at\">";
    if($datetime[0] != "today") {
    echo "".ON." ".$datetime[0]." ";
    }
    echo "".AT." ".$datetime[1]."</div>";
    echo "</td></tr></tbody> <tr class=\"res\"> <th>".RESOURCES."</th> <td colspan=\"2\"><span class=\"f10\">";
    echo "<img class=\"r1\" src=\"img/x.gif\" alt=\"Lumber\" title=\"".LUMBER."\" />".$recieve['wood']." | <img class=\"r2\" src=\"img/x.gif\" alt=\"Clay\" title=\"".CLAY."\" />".$recieve['clay']." | <img class=\"r3\" src=\"img/x.gif\" alt=\"Iron\" title=\"".IRON."\" />".$recieve['iron']." | <img class=\"r4\" src=\"img/x.gif\" alt=\"Crop\" title=\"".CROP."\" />".$recieve['crop']."</td></tr></tbody>";
    echo "</table>";
    }
}
if(count($market->sending) > 0) {
	echo "<h4>".OWN_MERCHANTS_ONWAY.":</h4>";
    foreach($market->sending as $send) {
        $villageowner = $database->getVillageField($send['to'],"owner");
        $ownername = $database->getUserField($villageowner,"username",0);
        echo "<table class=\"traders\" cellpadding=\"1\" cellspacing=\"1\">";
        echo "<thead><tr> <td><a href=\"spieler.php?uid=$villageowner\">$ownername</a></td>";
        echo "<td><a href=\"karte.php?d=".$send['to']."&c=".$generator->getMapCheck($send['to'])."\">".TRANSPORT_TO." ".$database->getVillageField($send['to'],"name")."</a></td>";
        echo "</tr></thead> <tbody><tr> <th>".ARRIVAL_IN."</th> <td>";
        echo "<div class=\"in\"><span id=timer".++$session->timer.">".$generator->getTimeFormat($send['endtime']-time())."</span> h</div>";
        $datetime = $generator->procMtime($send['endtime']);
        echo "<div class=\"at\">";
        if($datetime[0] != "today") {
        echo "".ON." ".$datetime[0]." ";
        }
        echo "".AT." ".$datetime[1]."</div>";
        echo "</td> </tr> <tr class=\"res\"> <th>".RESOURCES."</th><td>";
        echo "<img class=\"r1\" src=\"img/x.gif\" alt=\"Lumber\" title=\"".LUMBER."\" />".$send['wood']." | <img class=\"r2\" src=\"img/x.gif\" alt=\"Clay\" title=\"".CLAY."\" />".$send['clay']." | <img class=\"r3\" src=\"img/x.gif\" alt=\"Iron\" title=\"".IRON."\" />".$send['iron']." | <img class=\"r4\" src=\"img/x.gif\" alt=\"Crop\" title=\"".CROP."\" />".$send['crop']."</td></tr></tbody>";
        echo "</table>";
    }
}
if(count($market->return) > 0) {
	echo "<h4>".MERCHANTS_RETURNING.":</h4>";
    foreach($market->return as $return) {
        $villageowner = $database->getVillageField($return['from'],"owner");
        $ownername = $database->getUserField($villageowner,"username",0);
        echo "<table class=\"traders\" cellpadding=\"1\" cellspacing=\"1\">";
        echo "<thead><tr> <td><a href=\"spieler.php?uid=$villageowner\">$ownername</a></td>";
        echo "<td><a href=\"karte.php?d=".$return['from']."&c=".$generator->getMapCheck($return['from'])."\">".RETURNFROM." ".$database->getVillageField($return['from'],"name")."</a></td>";
        echo "</tr></thead> <tbody><tr> <th>".ARRIVAL_IN."</th> <td>";
        echo "<div class=\"in\"><span id=timer".++$session->timer.">".$generator->getTimeFormat($return['endtime']-time())."</span> h</div>";
        $datetime = $generator->procMtime($return['endtime']);
        echo "<div class=\"at\">";
        if($datetime[0] != "today") {
        echo "".ON." ".$datetime[0]." ";
        }
        echo "".AT." ".$datetime[1]."</div>";
        echo "</td> </tr>";
        echo "</tbody></table>";
    }
}
include("upgrade.tpl");
?>
</p></div> 
