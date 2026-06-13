<div id="textmenu">
   <a href="build.php?id=<?php echo $id; ?>" <?php

        if(!isset($_GET['t']) && $_GET['id'] == $id) {
        	echo "class=\"selected\"";
        }

?>
    "><?php echo OWN_ARTEFACTS; ?></a>
         
 | <a href="build.php?id=<?php echo $id; ?>&t=2" <?php

        if(isset($_GET['t']) && $_GET['t'] == 2) {
        	echo "class=\"selected\"";
        }

?>"><?php echo SMALL_ARTEFACTS; ?></a>

 | <a href="build.php?id=<?php echo $id; ?>&t=3" <?php

        if(isset($_GET['t']) && $_GET['t'] == 3) {
        	echo "class=\"selected\"";
        }
?>"><?php echo LARGE_ARTEFACTS; ?></a>

| <a href="build.php?id=<?php echo $id; ?>&t=4" <?php
    if(isset($_GET['t']) && $_GET['t'] == 4) {
        echo "class=\"selected\"";
    }
?>><?php echo UNIQUE_EFFECT; ?></a>
</div>
