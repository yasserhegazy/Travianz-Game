<?php
$dir = __DIR__ . '/Templates/Notice/';
$files = glob($dir . '*.tpl');

$replaces = [
    '>Attacker<' => '><?php echo ATTACKER; ?><',
    '>Defender<' => '><?php echo DEFENDER; ?><',
    '>Troops<' => '><?php echo TROOPS; ?><',
    '>Casualties<' => '><?php echo CASUALTIES; ?><',
    '>Prisoners<' => '><?php echo PRISONERS; ?><',
    '>Information<' => '><?php echo INFORMATION; ?><',
    '>Bounty<' => '><?php echo BOUNTY; ?><',
    ' from the village ' => ' <?php echo FROM_THE_VILL; ?> ',
    '\'from the village \'' => 'FROM_THE_VILL.\' \'',
    '>sender<' => '><?php echo SENDER; ?><',
    '"Reinforcement"' => 'REINFORCEMENT',
    '>Reinforcement<' => '><?php echo REINFORCEMENT; ?><'
];

foreach ($files as $file) {
    if (basename($file) == 'all.tpl') continue; // I will handle all.tpl manually or it's just an array of strings
    $content = file_get_contents($file);
    $new_content = strtr($content, $replaces);
    if ($content !== $new_content) {
        file_put_contents($file, $new_content);
        echo "Fixed " . basename($file) . "\n";
    }
}
