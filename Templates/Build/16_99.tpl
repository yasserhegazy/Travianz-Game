<div id="build" class="gid16">
    <a href="#" onclick="return Popup(16,4);" class="build_logo">
        <img class="g16" src="img/x.gif" alt="<?php echo RALLYPOINT;?>" />
    </a>

    <h1>
        <?php echo RALLYPOINT;?>
        <span class="level">
            <?php echo LEVEL;?> <?php echo $village->resarray['f'.$id]; ?>
        </span>
    </h1>

    <p class="build_desc"><?php echo RALLYPOINT_DESC;?></p>

    <?php include("16_menu.tpl"); ?>

    <div id="raidList">
        <?php include("Templates/goldClub/farmlist.tpl"); ?>
    </div>
</div>