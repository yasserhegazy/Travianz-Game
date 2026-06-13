<?php
#################################################################################
##              -= YOU MAY NOT REMOVE OR CHANGE THIS NOTICE =-                 ##
## --------------------------------------------------------------------------- ##
##  Filename       res.tpl                                                     ##
##  Developed by:  Dzoki                                                       ##
##  License:       TravianZ Project                                            ##
##  Copyright:     TravianZ (c) 2010-2025. All rights reserved.                ##
##                                                                             ##
#################################################################################
?>

<?php
// Natars cration script does not have village initialized
if (!empty($village)) {
    $wood            = round( $village->getProd( "wood" ) );
    $clay            = round( $village->getProd( "clay" ) );
    $iron            = round( $village->getProd( "iron" ) );
    $crop            = round( $village->getProd( "crop" ) );
    $totalproduction = $village->allcrop; // all crops + bakery + grain mill

    $awood = round($village->awood);
    $aclay = round($village->aclay);
    $airon = round($village->airon);
    $acrop = round($village->acrop);
    $maxstore = $village->maxstore;
    $maxcrop = $village->maxcrop;

    $woodPercent = ($maxstore > 0) ? min(100, max(0, round(($awood / $maxstore) * 100))) : 0;
    $clayPercent = ($maxstore > 0) ? min(100, max(0, round(($aclay / $maxstore) * 100))) : 0;
    $ironPercent = ($maxstore > 0) ? min(100, max(0, round(($airon / $maxstore) * 100))) : 0;
    $cropPercent = ($maxcrop > 0) ? min(100, max(0, round(($acrop / $maxcrop) * 100))) : 0;

    // Disable full storage red color, but apply red if wheat production is negative
    $woodClass = '';
    $clayClass = '';
    $ironClass = '';
    $cropClass = ($acrop < 0) ? ' crop-neg' : '';
?>

<div id="res">
<div id="resWrap">

	<div class="res-flex-container">
		<div class="res-pill-wrap">
			<div title="<?php echo number_format($wood); ?>" class="res-pill<?php echo $woodClass; ?>" data-prod="<?php echo $wood; ?>" data-max="<?php echo $maxstore; ?>" style="--fill-percent: <?php echo $woodPercent; ?>%;">
				<img src="img/x.gif" class="r1" alt="<?php echo LUMBER; ?>" title="<?php echo LUMBER; ?>" />
				<span id="l4" dir="ltr"><span class="res-cur"><?php echo number_format($awood); ?></span><span class="res-sep">/</span><span class="res-max"><?php echo number_format($maxstore); ?></span></span>
			</div>
		</div>

		<div class="res-pill-wrap">
			<div title="<?php echo number_format($clay); ?>" class="res-pill<?php echo $clayClass; ?>" data-prod="<?php echo $clay; ?>" data-max="<?php echo $maxstore; ?>" style="--fill-percent: <?php echo $clayPercent; ?>%;">
				<img src="img/x.gif" class="r2" alt="<?php echo CLAY; ?>" title="<?php echo CLAY; ?>" />
				<span id="l3" dir="ltr"><span class="res-cur"><?php echo number_format($aclay); ?></span><span class="res-sep">/</span><span class="res-max"><?php echo number_format($maxstore); ?></span></span>
			</div>
		</div>

		<div class="res-pill-wrap">
			<div title="<?php echo number_format($iron); ?>" class="res-pill<?php echo $ironClass; ?>" data-prod="<?php echo $iron; ?>" data-max="<?php echo $maxstore; ?>" style="--fill-percent: <?php echo $ironPercent; ?>%;">
				<img src="img/x.gif" class="r3" alt="<?php echo IRON; ?>" title="<?php echo IRON; ?>" />
				<span id="l2" dir="ltr"><span class="res-cur"><?php echo number_format($airon); ?></span><span class="res-sep">/</span><span class="res-max"><?php echo number_format($maxstore); ?></span></span>
			</div>
		</div>

		<?php if($acrop != 0){ ?>
		<div class="res-pill-wrap">
			<div title="<?php echo number_format($crop); ?>" class="res-pill<?php echo $cropClass; ?>" data-prod="<?php echo $crop; ?>" data-max="<?php echo $maxcrop; ?>" style="--fill-percent: <?php echo $cropPercent; ?>%;">
				<img src="img/x.gif" class="r4" alt="<?php echo CROP; ?>" title="<?php echo CROP; ?>" />
				<span id="11" dir="ltr">
    <span class="res-cur"><?php echo number_format($acrop); ?></span>
    <span class="res-sep">/</span>
    <span class="res-max"><?php echo number_format($maxcrop); ?></span>
</span>
			</div>
		</div>
		<?php }else{ ?>
		<div class="res-pill-wrap">
    <div title="<?php echo number_format($crop); ?>" class="res-pill <?php echo $cropClass; ?>" data-prod="<?php echo $crop; ?>" data-max="<?php echo $maxcrop; ?>" style="--fill-percent: <?php echo $cropPercent; ?>%;">
        <img src="img/x.gif" class="r4" alt="<?php echo CROP; ?>" title="<?php echo CROP; ?>" />
        <span dir="ltr">
            <span class="res-cur"><?php echo number_format($acrop); ?></span>
            <span class="res-sep">/</span>
            <span class="res-max"><?php echo number_format($maxcrop); ?></span>
        </span>
    </div>
</div>
		<?php } ?>
	</div>
    </div>
</div>


<style>
/* ===== Resource Bar — Number + Green Fill Indicator ===== */

/* Flexbox container for resources to enforce single-row layout */
#res { width: 100%; margin: 6px auto; }
.res-flex-container {
    display: flex !important;
    flex-wrap: nowrap !important;
    justify-content: center !important;
    align-items: center !important;
    gap: 4px;
    width: 100%;
}

.res-pill-wrap {
    flex: 1 1 25%;
    min-width: 0; /* Prevents flex items from overflowing container if content is wide */
}

/* Resource Pill — the health-bar container */
.res-pill {
    display: flex !important;
    flex-direction: row !important;
    align-items: center !important;
    justify-content: flex-start !important;
    gap: 5px !important;
    position: relative !important;
    overflow: hidden !important;
    width: 100% !important;
    box-sizing: border-box !important;
    background: #dcedc8 !important; /* light green = empty */
    border: 1px solid rgba(34,139,34,0.4);
    border-radius: 5px;
    padding: 5px 10px !important;
    color: #1a3a1a;
    font-weight: 900;
    font-size: 16px !important;
    line-height: 1;
    white-space: nowrap !important;
    z-index: 0 !important;
    box-shadow: 0 0 0 1px #228b22;
}

/* Green fill bar — grows left→right based on --fill-percent */
.res-pill::before {
    content: '';
    position: absolute;
    top: 0; left: 0; bottom: 0;
    width: var(--fill-percent, 0%);
    background: #4de055;
    border-radius: inherit;
    z-index: -1;
    transition: width 0.6s ease-out;
}

/* RTL: fill from right */
html[dir="rtl"] .res-pill::before { left: auto; right: 0; }

/* Icons and text sit above fill bar */
.res-pill > * { position: relative; z-index: 1; }

/* ── GLOBALLY hide the /capacity — bar is the indicator ── */
.res-sep,
.res-max { display: none !important; }

.res-cur {
    display: inline !important;
    direction: ltr;
    white-space: nowrap;
    font-size: inherit;
}

/* Full storage — solid full green */
.res-pill.res_full {
    color: #fff;
    box-shadow: 0 0 0 1px #006400, 0 0 6px rgba(0,180,0,0.5);
}
.res-pill.res_full::before {
    background: #22c55e !important;
    width: 100% !important;
}

/* Crop negative — red pill */
.res-pill.crop-neg {
    background: #fde8e8 !important;
    border-color: rgba(220,38,38,0.5);
    box-shadow: 0 0 0 1px #dc2626;
    color: #991b1b;
}
.res-pill.crop-neg::before {
    background: #FF4A4A !important;
}
.res-pill.res_full[data-prod^="-"]::before {
    background: #FF4A4A !important;
    width: 100% !important;
}

/* Negative production rate badge */
.res-prod-neg {
    display: inline-block !important;
    position: relative;
    z-index: 1;
    font-size: 11px !important;
    font-weight: 700;
    color: #fff;
    background: #dc2626;
    border-radius: 3px;
    padding: 1px 4px;
    margin-left: 3px;
    line-height: 1.2;
    white-space: nowrap;
    flex-shrink: 0;
}
html[dir="rtl"] .res-prod-neg {
    margin-left: 0;
    margin-right: 3px;
}

/* Resource icons */
.res-pill img {
    margin: 0 !important;
    display: inline-block !important;
    width: 16px !important;
    height: 14px !important;
    flex-shrink: 0 !important;
    opacity: 1 !important;
    visibility: visible !important;
}

/* Extra-narrow phones */
@media screen and (max-width: 480px) {
    .res-flex-container {
        gap: 4px !important;
    }
    .res-pill {
        padding: 4px 6px !important;
        font-size: 14px !important;
        gap: 3px !important;
    }
    .res-pill img {
        width: 14px !important;
        height: 12px !important;
    }
}
</style>




<script>
/* ═══════════════════════════════════════════════════════════════════
   Live Resource Health Bar — Self-contained Inline Timer
   ───────────────────────────────────────────────────────────────────
   Bypasses unx.js mb()/executeTimer() to guarantee live updates.
   Reads production rates from data-prod attributes set by PHP.
   Updates both text AND --fill-percent every tick.
   ═══════════════════════════════════════════════════════════════════ */
(function(){
    var pills = document.querySelectorAll('.res-pill[data-prod]');
    if(!pills.length) return;

    var startTime = Date.now();

    pills.forEach(function(pill){
        var outerSpan = pill.querySelector('span[id]') || pill.querySelector('span');
        if(!outerSpan) return;

        /* Target the .res-cur child if it exists, else the outer span */
        var curSpan = outerSpan.querySelector('.res-cur') || outerSpan;

        var prod   = parseFloat(pill.getAttribute('data-prod')) || 0;
        var maxRes = parseInt(pill.getAttribute('data-max'))    || 0;

        /* Read initial value from .res-cur text content (plain integer from PHP) */
        var startR = parseInt(curSpan.textContent.replace(/[^0-9\-]/g, '')) || 0;

        if(prod === 0 || maxRes === 0) return;

        pill._liveData = {
            curSpan : curSpan,
            outerSpan: outerSpan,
            prod    : prod,
            maxRes  : maxRes,
            startR  : startR,
            startT  : startTime
        };

        /* Neutralize duplicate timer from unx.js */
        if(outerSpan.id) outerSpan.removeAttribute('title');
    });

    function tick(){
        var now = Date.now();
        pills.forEach(function(pill){
            var d = pill._liveData;
            if(!d) return;

            var elapsed = now - d.startT; /* ms */
            var cur = Math.floor(d.startR + elapsed * (d.prod / 3600000));

            /* clamp */
if(cur > d.maxRes) cur = d.maxRes;
if(cur < 0 && !pill.classList.contains('crop-neg')) cur = 0;

            /* Update ONLY .res-cur — never touch .res-sep or .res-max */
            d.curSpan.textContent = String(cur).replace(/\B(?=(\d{3})+(?!\d))/g, ",");

            /* update health bar fill */
            var pct = Math.min(100, Math.max(0, (cur / d.maxRes) * 100));
            pill.style.setProperty('--fill-percent', pct.toFixed(1) + '%');

            /* full-state toggle */
            if(cur >= d.maxRes){
                pill.classList.add('res_full');
            } else {
                pill.classList.remove('res_full');
            }

            /* keep fb[] in sync for marketplace / trade forms */
            if(typeof fb !== 'undefined' && d.outerSpan.id){
                if(!fb[d.outerSpan.id]) fb[d.outerSpan.id] = {};
                fb[d.outerSpan.id].value = cur;
            }
        });
    }

    /* Fire immediately, then every 100ms — smooth rapid-looking updates */
    tick();
    setInterval(tick, 100);
})();
</script>

<?php
}
