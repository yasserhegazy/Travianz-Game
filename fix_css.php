<?php
$file = 'mobile/_phone_statistics.css';
$content = file_get_contents($file);
$content = preg_replace('/div#content\.statistics td\.pop::before \{ content: \".*?\";/i', 'div#content.statistics td.pop::before { content: "\xF0\x9F\x91\xA5";', $content);
$content = preg_replace('/div#content\.statistics td\.vil::before, div#content\.statistics td\.hab::before \{ content: \".*?\";/i', 'div#content.statistics td.vil::before, div#content.statistics td.hab::before { content: "\xF0\x9F\x8F\xA0";', $content);
$content = preg_replace('/div#content\.statistics td\.po::before \{ content: \".*?\";/i', 'div#content.statistics td.po::before { content: "\xE2\x9A\x94\xEF\xB8\x8F";', $content);
$content = preg_replace('/div#content\.statistics td\.xp::before \{ content: \".*?\";/i', 'div#content.statistics td.xp::before { content: "\xE2\x9C\xA8";', $content);
$content = preg_replace('/div#content\.statistics td\.lev::before \{ content: \".*?\";/i', 'div#content.statistics td.lev::before { content: "\xE2\xAD\x90";', $content);
$content = preg_replace('/div#content\.statistics td\.val::before \{ content: \".*?\";/i', 'div#content.statistics td.val::before { content: "\xF0\x9F\x94\xA5";', $content);
$content = preg_replace('/div#content\.statistics td\.av::before \{ content: \".*?\";/i', 'div#content.statistics td.av::before { content: "\xF0\x9F\x9B\xA1\xEF\xB8\x8F";', $content);
file_put_contents($file, $content);
?>
