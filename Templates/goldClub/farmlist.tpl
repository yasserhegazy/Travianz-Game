<?php
$res = mysqli_query($database->dblink, "SHOW COLUMNS FROM ".TB_PREFIX."raidlist LIKE 'sort_order'");
if(mysqli_num_rows($res) == 0) {
    mysqli_query($database->dblink, "ALTER TABLE ".TB_PREFIX."raidlist ADD COLUMN sort_order INT(11) NOT NULL DEFAULT 0");
}

if(isset($_GET['t']) == 99 && isset($_GET['action']) == 0) {

// --- Handle rename action ---
if(isset($_POST['action']) && $_POST['action'] == 'renameList' && !empty($_POST['lid']) && !empty($_POST['newname']) && isset($_POST['c']) && $_POST['c'] == $session->mchecker){
    $rlid = (int)$_POST['lid'];
    $rnewname = trim($_POST['newname']);
    if($rnewname !== '') {
        $database->renameFarmList($rlid, $session->uid, $rnewname);
        $session->changeChecker();
    }
    header("Location: build.php?id=39&t=99");
    exit;
}

if(isset($_GET['t']) == 99 && isset($_POST['action']) == 'addList' && !empty($_POST['did']) && !empty($_POST['name']) && $database->getVillageField($_POST['did'], 'owner') == $session->uid){
    $database->createFarmList($_POST['did'], $session->uid, $_POST['name']);
}else if(isset($_GET['t']) == 99 && isset($_POST['action']) == 'addList'){
	header("Location: build.php?gid=16&t=99&action=addList");
	exit;
}

// --- Auto-create default farmlist if user has none ---
if(!$database->getVilFarmlist($session->uid)) {
    $defaultName = (defined('LANG') && LANG === 'ar') ? 'القائمة الأساسية' : 'Default List';
    $database->createFarmList($village->wid, $session->uid, $defaultName);
}
$protectedSlots = isset($_SESSION['raidlist_protected_slots']) ? array_map('intval', $_SESSION['raidlist_protected_slots']) : [];
$blockedCount = isset($_SESSION['raidlist_protection_blocked'])
    ? (int)$_SESSION['raidlist_protection_blocked']
    : 0;
	$protectedSlots = isset($_SESSION['raidlist_protected_slots']) ? array_map('intval', $_SESSION['raidlist_protected_slots']) : [];
$blockedCount = isset($_SESSION['raidlist_protection_blocked'])
    ? (int)$_SESSION['raidlist_protection_blocked']
    : 0;

$blockedBySender = isset($_SESSION['raidlist_blocked_sender']) ? (int)$_SESSION['raidlist_blocked_sender'] : 0;
$blockedByTarget = isset($_SESSION['raidlist_blocked_target']) ? (int)$_SESSION['raidlist_blocked_target'] : 0;
$successCount = isset($_SESSION['raidlist_success_count']) ? (int)$_SESSION['raidlist_success_count'] : 0;
?>
<?php if(isset($_SESSION['raidlist_result_ready']) && ($successCount > 0 || $blockedCount > 0)){ ?>
<div class="farmlistResultBox">

    <?php if($successCount > 0){ ?>
        <div class="farmlistResultLine success">
            <img class="att2" src="img/x.gif" alt="">
            <span>تم إرسال <?php echo $successCount; ?> هجوم بنجاح</span>
        </div>
    <?php } ?>

    <?php if($blockedBySender > 0){ ?>
        <div class="farmlistResultLine failed">
            <span class="failIcon">❌</span>
            <span>فشل إرسال <?php echo $blockedBySender; ?> هجوم لأنك تحت الحماية</span>
        </div>
    <?php } ?>

    <?php if($blockedByTarget > 0){ ?>
        <div class="farmlistResultLine failed">
            <span class="failIcon">❌</span>
            <span>فشل إرسال <?php echo $blockedByTarget; ?> هجوم لأن الهدف تحت الحماية</span>
        </div>
    <?php } ?>

</div>
<?php } ?>
<form action="build.php?id=39&t=99&action=startRaid" method="post" name="msg">
<input type="hidden" name="action" value="startRaid">
<?php 
$sql = mysqli_query($database->dblink,"SELECT id, name, owner, wref FROM ".TB_PREFIX."farmlist WHERE owner = ".(int) $session->uid." ORDER BY wref DESC");
$query = mysqli_num_rows($sql);
while($row = mysqli_fetch_array($sql)){
    $lid = $row["id"];
    $lname = $row["name"];
    $lowner = $row["owner"];
    $lwref = $row["wref"];
    $lvname = $database->getVillageField($row["wref"], 'name');
?>
                        <div class="listTitleText">
							<a href="build.php?gid=16&t=99&action=deleteList&lid=<?php echo $lid; ?>"><img class="del" src="img/x.gif" alt="delete" title="delete"></a>
                            <?php echo $lvname; ?> - <span id="listName_<?php echo $lid; ?>"><?php echo htmlspecialchars($lname); ?></span>
                            <a href="#" onclick="document.getElementById('renameDiv_<?php echo $lid; ?>').style.display='inline'; this.style.display='none'; return false;" title="<?php echo (defined('LANG') && LANG === 'ar') ? 'تعديل الاسم' : 'Rename'; ?>" style="margin-right:5px; margin-left:5px; cursor:pointer; font-size:11px;">✏️</a>
                            <div id="renameDiv_<?php echo $lid; ?>" style="display:none; margin:0; padding:0; display:none;">
                                <input type="text" id="renameName_<?php echo $lid; ?>" value="<?php echo htmlspecialchars($lname); ?>" maxlength="100" style="width:120px; font-size:11px;">
                                <button type="button" onclick="submitRename(<?php echo $lid; ?>, '<?php echo $session->mchecker; ?>')" style="font-size:10px; cursor:pointer; padding:1px 6px;"><?php echo (defined('LANG') && LANG === 'ar') ? 'حفظ' : 'Save'; ?></button>
                            </div>
                        </div>
                        <div class="openedClosedSwitch switchOpened"></div>
                        <div class="clear"></div>
                                            </div>
	<div class="listContent ">
    <div class="detail">

    <div class="clear"></div>
    <div class="addSlot" style="margin-bottom: 10px; display:flex; justify-content:flex-end; align-items:center;">
        <button type="button" class="trav_buttons farmBtn" onclick="window.location.href = '?gid=16&t=99&action=addraid&lid=<?php echo $lid; ?>';">
    إضافة مزرعة
</button>
<span class="goldCost">
    5 <img src="img/x.gif" class="gold" alt="Gold">
</span>
        
    </div>
    <table id="raidList" cellpadding="1" cellspacing="1">
        <thead>
            <tr>
                <td></td>
                <td><?php echo (defined('LANG') && LANG === 'ar') ? 'القرية' : 'Village'; ?></td>
                <td><?php echo (defined('LANG') && LANG === 'ar') ? 'القوات' : 'Troops'; ?></td>
				<td><?php echo (defined('LANG') && LANG === 'ar') ? 'المسافة' : 'Distance'; ?></td>                
                <td><?php echo (defined('LANG') && LANG === 'ar') ? 'أخر هجوم' : 'Last raid'; ?></td>
                <td></td>
            </tr>
        </thead>
        <tbody>

<?php
$sql2 = mysqli_query($database->dblink,"SELECT * FROM ".TB_PREFIX."raidlist WHERE lid = ".(int) $lid." ORDER BY sort_order ASC, distance ASC");
$query2 = mysqli_num_rows($sql2);
if(!$query2) echo '<td class="noData" colspan="6">'.NO_VILLAGES.'</td>';
else
{
	while($row = mysqli_fetch_array($sql2)){
		$id = $row['id'];
		$lid = $row['lid'];
		$towref = $row['towref'];
		$slotWasProtected = in_array((int)$id, $protectedSlots);
        $targetIsProtected = $database->hasBeginnerProtection($towref);
		$x = $row['x'];
		$y = $row['y'];
		$distance = $row['distance'];
		
		for($i = 1; $i <= 6; $i++) ${'t'.$i} = $row['t'.$i];
		
		$vdata = $database->getVillage($towref);
?>

<tr class="slotRow">
<td class="checkbox">
                <input id="slot<?php echo $id; ?>" name="slot[]" value="<?php echo $id; ?>" type="checkbox" class="markSlot">
			</td>
            <td class="village">
            <?php
           if ($slotWasProtected) {
    echo '<span style="color:#c00000;font-weight:bold;font-size:16px;margin:0 4px;" title="فشل الهجوم: القرية تحت الحماية">❌</span>';
}
            $attacks = $database->getMovement(3, $towref, 1);      
            if (($attacksCount = count($attacks)) > 0) {
            	foreach($attacks as $attack){
            		if($attack['attack_type'] != 4) $attacksCount -= 1;
                }          
                if($attacksCount > 0) echo '<img class="att2" src="img/x.gif" title="'.OWN_ATTACKING_TROOPS.'" />';
            }
        	?>
                <label for="slot<?php echo $id; ?>">
                <?php
                    $oasistype = $database->getVillageType2($towref);
                    if($oasistype != 0) $thisVillageName = $database->getOasisField($towref, 'conqured') ? OCCUOASIS : UNOCCUOASIS;
                    else $thisVillageName = $vdata["name"];
                ?>
                <a class="farmVillageName" href="karte.php?d=<?php echo $towref; ?>&c=<?php echo $generator->getMapCheck($towref); ?>">
    <?php echo $thisVillageName; ?>
</a>
                </label>
</td>

<td class="troops">
<?php
$start = ($session->tribe - 1) * 10 + 1;
$end = $start + 5;

for($i = $start; $i <= $end; $i++){
    if(${'t'.($i - $start + 1)} > 0){
        echo '<div class="troopIcon"><img class="unit u'.$i.'" title="'.$technology->getUnitName($i).'" src="img/x.gif"><span class="troopIconAmount">'.number_format(${'t'.($i - $start + 1)}).'</span></div>';
    }
}
?>
</td>

<td class="distance"><?php echo $distance; ?></td>
            


            

                
            </td>
            <td class="lastRaid">
<?php
$noticeClass = ["Scout Report", "Won as attacker without losses", "Won as attacker with losses", "Lost as attacker with losses", "Won as defender without losses", "Won as defender with losses", "Lost as defender with losses", "Lost as defender without losses",
						"Reinforcement arrived", "", "Wood Delivered", "Clay Delivered", "Iron Delivered", "Crop Delivered", "", "Won as defender without losses", "Won as defender with losses", "Lost as defender with losses", "Won scouting as attacker", "Lost scouting as attacker",
						"Won scouting as defender", "Lost scouting as defender"];

$getnotice = mysqli_query($database->dblink,"SELECT ntype, data, time, id FROM ".TB_PREFIX."ndata WHERE ntype < 4 AND toWref = ".(int) $towref." AND uid = ".(int) $session->uid." ORDER BY time DESC Limit 1");
if(mysqli_num_rows($getnotice) > 0){
while($row2 = mysqli_fetch_array($getnotice)){
    $dataarray = explode(",",$row2['data']);
    $type2 = $row2['ntype'];
    echo "<img src=\"img/x.gif\" class=\"iReport iReport".$row2['ntype']."\" title=\"".$noticeClass[$type2]."\"> ";
    
    $allres = $dataarray[23] + $dataarray[24] + $dataarray[25] + $dataarray[26];
    $carry = $dataarray[27];

    echo "<img title=\"$allres/$carry\" src=\"img/x.gif\" class=\"carry\"/>";
    
    $date = $generator->procMtime($row2['time']);
    echo "<a href=\"berichte.php?id=".$row2['id']."\">".$date[0]." ".date('H:i',$row2['time'])."</a> ";
}
}
?>
                <div class="clear"></div>
            </td>
            <td class="action">
                <a class="farmEditIcon" href="build.php?id=39&t=99&action=showSlot&eid=<?php echo $id; ?>" title="تعديل">✏️</a>
            </td>
            </tr>
<?php
}
}
?>
    
</tbody>
    </table>
<div class="clear"></div><br />
<div class="troopSelection">
<div class="clear"></div>
</div>
</div>
<?php }?>


<?php if($database->getVilFarmlist($session->uid)){ ?>
<div class="markAll">
	<input type="checkbox" id="raidListMarkAll" name="s10" class="markAll" onclick="toggleAllSlots(this)">
	<label for="raidListMarkAll"><?php echo (defined('LANG') && LANG === 'ar') ? 'تحديد الكل' : 'Select all'; ?></label>
</div><br />
<div class="addSlot">
    <div>
        <button type="submit" class="trav_buttons farmBtn" value="Start Raid">بدء الهجوم</button>
<span class="goldCost">
    1 <img src="img/x.gif" class="gold" alt="Gold">
</span>
<span class="goldText">
    لكل هجمة
</span>
    </div>
</div><br />
<?php } ?>
<div class="options">
    <a class="arrow" href="build.php?gid=16&t=99&action=addList"><?php echo (defined('LANG') && LANG === 'ar') ? 'إنشاء قائمة جديدة' : 'Create a new list'; ?></a>
</div>
<?php
}

?>
</form>
<?php
if(!isset($create)) $create = 0;
if($create == 1){
	$hideevasion = 1;
	include("Templates/goldClub/farmlist_add.tpl");
}else if($create == 2){
	$hideevasion = 1;
	include("Templates/goldClub/farmlist_addraid.tpl");
}else if($create == 3){
	$hideevasion = 1;
	include("Templates/goldClub/farmlist_editraid.tpl");
}
?>

<style>
/* visual feedback for drag and drop and sorting */
table#raidList thead td { transition: background-color 0.2s; }
table#raidList thead td:hover { background-color: rgba(200,200,200,0.3); }
tr.slotRow.dragging { background-color: #f0f0f0; opacity: 0.6; }

.farmlistResultBox{
    background:#f6fbe8;
    border:1px solid #d7e4b2;
    padding:8px 12px;
    margin:10px 0 14px 0;
    text-align:center;
    font-size:13px;
    line-height:24px;
}

.farmlistResultLine{
    display:block;
    font-weight:normal;
}

.farmlistResultLine.success{
    color:#2f5f00;
}

.farmlistResultLine.failed{
    color:#b30000;
}

.farmlistResultLine img.att2{
    vertical-align:middle;
    margin-left:4px;
    margin-right:4px;
}

.failIcon{
    font-size:15px;
    vertical-align:middle;
}
</style>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const tables = document.querySelectorAll('table#raidList');
    tables.forEach((table, index) => {
        const ths = table.querySelectorAll('thead td');
        
        // 1. Column Sorting
        ths.forEach(th => {
            th.style.cursor = "pointer";
            th.title = "<?php echo (defined('LANG') && LANG === 'ar') ? 'اضغط للترتيب' : 'Click to sort'; ?>";
            th.addEventListener('click', () => {
                const tbody = table.querySelector('tbody');
                const rows = Array.from(tbody.querySelectorAll('tr.slotRow'));
                let asc = th.dataset.asc === 'true' || false;
                th.dataset.asc = !asc;
                
                rows.sort((a, b) => {
                    let aCol = a.children[th.cellIndex];
                    let bCol = b.children[th.cellIndex];
                    if(!aCol || !bCol) return 0;
                    
                    let aText = aCol.textContent.replace(/[^0-9.-]/g, '').trim(); 
                    if(aText === '') aText = aCol.textContent.trim();
                    let bText = bCol.textContent.replace(/[^0-9.-]/g, '').trim();
                    if(bText === '') bText = bCol.textContent.trim();
                    
                    let aNum = parseFloat(aText);
                    let bNum = parseFloat(bText);
                    
                    if(!isNaN(aNum) && !isNaN(bNum)) {
                        return asc ? aNum - bNum : bNum - aNum;
                    } else {
                        return asc ? aCol.textContent.trim().localeCompare(bCol.textContent.trim()) : bCol.textContent.trim().localeCompare(aCol.textContent.trim());
                    }
                });
                
                rows.forEach(row => tbody.appendChild(row));
                saveOrder(tbody);
            });
        });

        // 2. Drag and Drop sorting
        const tbody = table.querySelector('tbody');
        let draggedRow = null;
        
        const rows = tbody.querySelectorAll('tr.slotRow');
        rows.forEach(row => {
            row.draggable = true;
            row.style.cursor = "move";
            row.title = "<?php echo (defined('LANG') && LANG === 'ar') ? 'اسحب لإعادة الترتيب' : 'Drag to reorder'; ?>";
            
            row.addEventListener('dragstart', function(e) {
                draggedRow = row;
                e.dataTransfer.effectAllowed = 'move';
                row.classList.add('dragging');
            });
            
            row.addEventListener('dragend', function() {
                row.classList.remove('dragging');
                draggedRow = null;
                saveOrder(tbody);
            });
            
            row.addEventListener('dragover', function(e) {
                e.preventDefault();
                if(!draggedRow) return;
                const afterElement = getDragAfterElement(tbody, e.clientY);
                if (afterElement == null) {
                    tbody.appendChild(draggedRow);
                } else {
                    tbody.insertBefore(draggedRow, afterElement);
                }
            });
        });
    });

    function getDragAfterElement(container, y) {
        const draggableElements = [...container.querySelectorAll('tr.slotRow:not(.dragging)')];
        return draggableElements.reduce((closest, child) => {
            const box = child.getBoundingClientRect();
            const offset = y - box.top - box.height / 2;
            if (offset < 0 && offset > closest.offset) {
                return { offset: offset, element: child };
            } else {
                return closest;
            }
        }, { offset: Number.NEGATIVE_INFINITY }).element;
    }

    function saveOrder(tbody) {
        const rows = tbody.querySelectorAll('tr.slotRow');
        let order = [];
        rows.forEach(row => {
            const cb = row.querySelector('input.markSlot');
            if(cb) order.push(cb.value);
        });
        
        if(order.length === 0) return;
        
        let formData = new FormData();
        order.forEach((id, index) => {
            formData.append('order['+index+']', id);
        });
        
        fetch('ajax_farmsort.php', {
            method: 'POST',
            body: formData
        }).then(res => res.text()).then(txt => console.log('saved'));
    }
});

// Toggle all farm slot checkboxes
function toggleAllSlots(source) {
    var checkboxes = document.querySelectorAll('input.markSlot');
    for (var i = 0; i < checkboxes.length; i++) {
        checkboxes[i].checked = source.checked;
    }
}

// Rename handler — creates and submits a temporary form OUTSIDE the main raid form
function submitRename(lid, checker) {
    var newname = document.getElementById('renameName_' + lid).value;
    if (!newname || !newname.trim()) return;
    var f = document.createElement('form');
    f.method = 'post';
    f.action = 'build.php?id=39&t=99';
    f.style.display = 'none';
    var fields = {action: 'renameList', lid: lid, c: checker, newname: newname};
    for (var key in fields) {
        var inp = document.createElement('input');
        inp.type = 'hidden';
        inp.name = key;
        inp.value = fields[key];
        f.appendChild(inp);
    }
    document.body.appendChild(f);
    f.submit();
}
</script>
<?php
unset($_SESSION['raidlist_protected_slots']);
unset($_SESSION['raidlist_protection_blocked']);
unset($_SESSION['raidlist_success_slots']);
unset($_SESSION['raidlist_success_count']);
unset($_SESSION['raidlist_blocked_sender']);
unset($_SESSION['raidlist_blocked_target']);
unset($_SESSION['raidlist_result_ready']);
?>

