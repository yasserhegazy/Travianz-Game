<?php
include_once("GameEngine/Artifacts.php");
include_once("GameEngine/sys_x8.php");

$ownArtifacts = $database->getOwnArtefactsInfo($session->uid);
$wref = $village->wid;
$coor = $database->getCoor($wref);

// Return an owned artifact to the Natars for 2000 gold (mirrors the joker reroll flow below).
// Only real artifacts can be returned here; WW building plans (type 15/16) are excluded.
if (isset($_GET['returnartefact']) && (int)$_GET['returnartefact'] > 0 && $session->gold >= 2000) {
    $returnId = (int)$_GET['returnartefact'];
    foreach ($ownArtifacts as $artifactToReturn) {
        if ((int)$artifactToReturn['id'] === $returnId && !in_array((int)$artifactToReturn['type'], [15, 16], true)) {
            $database->updateUserField($session->uid, 'gold', $session->gold - 2000, 1);
            $artifact = new Artifacts();
            $artifact->returnArtifactToNatars($artifactToReturn);
            header("Location: build.php?id=" . $id);
            exit;
        }
    }
}

?>
<body>
<div class="gid27">
<table id="own" cellpadding="1" cellspacing="1">
<thead>
<tr>
<th colspan="4"><?php echo OWN_ARTEFACTS; ?></th>
</tr>
<tr>
<td></td>
<td><?php echo NAME; ?></td>
<td><?php echo VILLAGE; ?></td>
<td><?php echo CONQUERED; ?></td>
</tr>
</thead>

<tbody>
<?php

if (empty($ownArtifacts)) echo '<tr><td colspan="4" class="none">'.ANY_ARTEFACTS.'</td></tr>';
else 
{
    foreach($ownArtifacts as $ownArtifact){
        $coor2 = $database->getCoor($ownArtifact['vref']);
        $ownArtifactInfo = Artifacts::getArtifactInfo($ownArtifact);
        echo '<tr><td class="icon"><img class="artefact_icon_' . $ownArtifact['type'] . '" src="img/x.gif"></td>';
        echo '<td class="nam">
                <a href="build.php?id='.$id . '&show='.$ownArtifact['id'].'">' . $ownArtifact['name'] . '</a> <span class="bon">' . $ownArtifact['effect'] . '</span>
                <div class="info">
                    Treasury <b>'.$ownArtifactInfo['requiredLevel'].'</b>, Effect <b>'.$ownArtifactInfo['effectInfluence'].'</b>
                </div>';
				if ((int)$ownArtifact['type'] == 8) {
    $jokerSize = isset($ownArtifact['size']) ? (int)$ownArtifact['size'] : 1;

    $jokerEffect = sys_x8::getOrCreateEffect(
        $ownArtifact['id'],
        $session->uid,
        $ownArtifact['vref'],
        $jokerSize
    );

    echo '<div class="info" style="margin-top:4px;color:#8B0000;">
        <b>مفعول الجوكر الحالي:</b> '.$jokerEffect['effect_name'].' 
        <span>('.$jokerEffect['rarity'].')</span>
    </div>';
	if (isset($_GET['rerolljoker']) && $session->gold >= 100) {

    $database->updateUserField(
        $session->uid,
        'gold',
        $session->gold - 100,
        1
    );

    $artefactId = (int)$_GET['rerolljoker'];

    foreach ($ownArtifacts as $artifactCheck) {

        if (
            (int)$artifactCheck['id'] == $artefactId &&
            (int)$artifactCheck['type'] == 8
        ) {

            $jokerSize = isset($artifactCheck['size'])
                ? (int)$artifactCheck['size']
                : 1;

            sys_x8::rerollEffect(
                $artefactId,
                $session->uid,
                $artifactCheck['vref'],
                $jokerSize
            );

            header("Location: build.php?id=".$id);
            exit;
        }
    }
}

echo '
<div style="margin-top:6px;">
<a href="?id='.$id.'&rerolljoker='.$ownArtifact['id'].'">
تغيير التأثير (100 ذهب)
</a>
</div>';
        } // close the joker (type==8) block — only jokers get the reroll link

        if (!in_array((int)$ownArtifact['type'], [15, 16], true)) {
            echo '
<div style="margin-top:6px;">
<a href="build.php?id='.$id.'&returnartefact='.$ownArtifact['id'].'">
اعادة التحفة (2000 ذهب)
</a>
</div>';
        }
        echo '</td>';
        echo '<td class="pla"><a href="karte.php?d=' . $ownArtifact['vref'] . '&c=' . $generator->getMapCheck($ownArtifact['vref']) . '">' . $database->getVillageField($ownArtifact['vref'], "name") . '</a></td>';
        echo '<td class="dist">'.date("d.m.Y H:i", $ownArtifact['conquered']) . '</td></tr>';
    }
}
?>
</tbody>
</table>


</div>
