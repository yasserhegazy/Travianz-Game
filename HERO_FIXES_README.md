# إصلاحات نظام البطل (Hero System Bug Fixes)

> **تاريخ الإصلاح:** مايو 2026  
> **الملفات المعدّلة:** `GameEngine/Battle.php` — `GameEngine/Automation.php`  
> **المشاكل المُصلَحة:** ٣ مشاكل رئيسية في نظام البطل

---

## نظرة عامة على المشاكل

كان نظام البطل يعاني من ٣ أخطاء متشعبة ومترابطة:

| # | المشكلة | الملف المسبّب |
|---|---------|--------------|
| 1 | البطل يموت تلقائياً حتى في الواحات والقرى الفارغة | `Battle.php` |
| 2 | عمود البطل (⭐) يختفي عند إرساله مع جيش | `Automation.php` |
| 3 | رسائل البطل (XP، المعلومات) تختفي تماماً من التقرير | `Automation.php` |

---

## ─────────────────────────────────────────────────────
## الإصلاح الأول: موت البطل التلقائي
## الملف: `GameEngine/Battle.php`
## ─────────────────────────────────────────────────────

### 📍 الموقع في الملف
ابحث عن هذا السطر في الملف (حوالي السطر **619**):

```php
if (isset($units['Att_unit']['hero']) && $units['Att_unit']['hero'] >0){
```

---

### ❌ الكود القديم (قبل الإصلاح)
```php
if (isset($units['Att_unit']['hero']) && $units['Att_unit']['hero'] >0){

    $_result = mysqli_query($database->dblink,"select heroid, health from " . TB_PREFIX . "hero where `dead`='0' and `heroid`=".(int) $atkhero['heroid']);
    $fdb = mysqli_fetch_array($_result);
    $hero_id = (int) $fdb['heroid'];
    $hero_health = $fdb['health'];
    $damage_health = round(100 * $result[1]);

    if ($hero_health <= $damage_health || $damage_health > 90){
        //hero die
        $result['casualties_attacker'][11] = 1;
        mysqli_query($database->dblink,"update " . TB_PREFIX . "hero set `dead` = 1, `health` = 0 where `heroid`=".(int) $hero_id);
    }else{
        mysqli_query($database->dblink,"update " . TB_PREFIX . "hero set `health`=`health`-".(int) $damage_health." where `heroid`=".(int) $hero_id);
    }
}
unset($_result, $fdb, $hero_id, $hero_health, $damage_health);
```

---

### ✅ الكود الجديد (بعد الإصلاح)
```php
// ─── Hero Combat Damage Resolution ────────────────────────────────────────
// Apply damage to the attacker's hero if one was sent into battle.
// Guards against null DB results when attacking empty targets (oases, abandoned villages).
if (isset($units['Att_unit']['hero']) && $units['Att_unit']['hero'] > 0) {

    // Fetch the active hero record – must exist and not already be dead
    $heroQuery  = "SELECT heroid, health FROM " . TB_PREFIX . "hero
                   WHERE dead = 0 AND heroid = " . (int) $atkhero['heroid'];
    $heroResult = mysqli_query($database->dblink, $heroQuery);
    $heroRecord = $heroResult ? mysqli_fetch_array($heroResult) : null;

    // Only process damage when a valid hero record exists
    if (!empty($heroRecord) && (int) $heroRecord['heroid'] > 0) {

        $hero_id      = (int)   $heroRecord['heroid'];
        $hero_health  = (float) $heroRecord['health'];
        $damage_dealt = (int)   round(100 * $result[1]);

        if ($hero_health <= $damage_dealt || $damage_dealt > 90) {
            // Hero has fallen in battle
            $result['casualties_attacker'][11] = 1;
            mysqli_query($database->dblink, "UPDATE " . TB_PREFIX . "hero
                SET dead = 1, health = 0
                WHERE heroid = " . $hero_id);
        } else {
            // Hero survived – reduce health by damage sustained
            mysqli_query($database->dblink, "UPDATE " . TB_PREFIX . "hero
                SET health = health - " . $damage_dealt . "
                WHERE heroid = " . $hero_id);
        }
    }

    unset($heroQuery, $heroResult, $heroRecord, $hero_id, $hero_health, $damage_dealt);
}
// ─────────────────────────────────────────────────────────────────────────
```

### 🔍 سبب المشكلة
الكود القديم كان يقرأ بيانات البطل من قاعدة البيانات مباشرةً دون التحقق من وجودها.
عند مهاجمة واحة فارغة (لا توجد قوات مدافعة)، كانت قاعدة البيانات ترجع `null`، فيقوم الكود
بحساب `0 <= 0` مما يُعلن موت البطل فوراً.

### ✔️ ماذا فعل الإصلاح
أضفنا حارس تحقق `if (!empty($heroRecord) && heroid > 0)` يمنع أي عملية حسابية على صحة
البطل ما لم يكن هناك سجل بطل صالح وحي في قاعدة البيانات.

---

## ─────────────────────────────────────────────────────
## الإصلاح الثاني: رسائل البطل واختفاء أيقونته
## الملف: `GameEngine/Automation.php` — السطر ~1301
## ─────────────────────────────────────────────────────

### 📍 الموقع في الملف
ابحث عن هذا السطر (حوالي السطر **1300**):

```php
$info_cat = $info_chief = $info_ram = $info_hero = ",";
```

---

### ❌ الكود القديم (قبل الإصلاح)
```php
//Data for when troops return.
//catapults look :D
$info_cat = $info_chief = $info_ram = $info_hero = ",";
```

---

### ✅ الكود الجديد (بعد الإصلاح)
```php
// ─── Battle Info Variables ──────────────────────────────────────────────────
// Initialise all info fields used when generating the report CSV.
// hero_pic must be set here as a fallback to guarantee the hero
// information row is always rendered in the report template.
$info_cat   = ",";
$info_chief = ",";
$info_ram   = ",";
$info_hero  = ",";
$hero_pic   = $hero_pic ?? 'hero';
// ────────────────────────────────────────────────────────────────────────────
```

### 🔍 سبب المشكلة
المتغير `$hero_pic` كان يُعيَّن فقط في مسارات معينة من الكود (هجوم ناجح مع خصم).
عند مهاجمة واحة فارغة أو استخدام مسار تقرير مختلف، كان `$hero_pic` غير معرّف.
القالب كان يتحقق من `!empty($dataarray[196])` ليُقرر عرض قسم "المعلومات"، فلما كان
`$hero_pic` فارغاً، كان القسم بأكمله يختفي.

### ✔️ ماذا فعل الإصلاح
أضفنا سطراً واحداً `$hero_pic = $hero_pic ?? 'hero'` يضمن أن قيمة `hero_pic` موجودة
دائماً بغض النظر عن مسار المعركة، مما أعاد ظهور رسائل البطل في جميع الحالات.

---

## ─────────────────────────────────────────────────────
## الإصلاح الثالث: اختفاء عمود البطل ⭐ وتشفيت الجداول
## الملف: `GameEngine/Automation.php` — السطر ~2255 و ~2264
## ─────────────────────────────────────────────────────

### 📍 الموقع في الملف
ابحث عن سطر `$data2 =` بعد بلوك `$info_spy` (توجد نسختان: واحدة للمهاجمة/الاستكشاف
وأخرى للهجوم العادي).

---

### 🔵 التغيير أ: مسار الاستكشاف والنهب (Spy/Raid path)

#### ❌ الكود القديم
```php
$data2 = ''.$from['owner'].','.$from['wref'].','.$owntribe.','
         .$unitssend_att.','.$unitsdead_att.',0,0,0,0,0,'
         .$to['owner'].','.$to['wref'].','.addslashes($to['name'])
         .',,,,'.$targettribe.','
         // ... (سطر واحد طويل جداً)
         .$info_ram.','.$info_cat.','.$info_chief.','.$info_spy.','
         .$data['t11'].','.$dead11.','.$herosend_def.','.$deadhero.',,'.$unitstraped_att;
```

> ⚠️ **المشكلة:** `$info_spy` كان يُكتب مباشرةً دون التحقق من وجوده. عندما لا يكون
> التقرير من نوع استكشاف (spy)، يكون `$info_spy` غير معرّف، فيُكتب سطر CSV ناقص
> بحقل مفقود مما يُسبب إزاحة كل الأعمدة التالية، ومنها عمود البطل.

#### ✅ الكود الجديد
```php
// Build report CSV — spy/raid path (resources not looted)
$spy_info = isset($info_spy) ? $info_spy : ',';
$data2 = implode(',', [
    $from['owner'], $from['wref'], $owntribe,
    $unitssend_att, $unitsdead_att,
    0, 0, 0, 0, 0,                          // no loot on spy raids
    $to['owner'], $to['wref'], addslashes($to['name']),
    '', '', '',                              // reserved fields
    $targettribe,
    $unitssend_def[0], $unitsdead_def[0], $rom,
    $unitssend_def[1], $unitsdead_def[1], $ger,
    $unitssend_def[2], $unitsdead_def[2], $gal,
    $unitssend_def[3], $unitsdead_def[3], $nat,
    $unitssend_def[4], $unitsdead_def[4], $natar,
    $unitssend_def[5], $unitsdead_def[5],
    $DefenderHeroesTot, $DefenderHeroesDead,
    $info_ram, $info_cat, $info_chief, $spy_info,
    $data['t11'], $dead11,
    $herosend_def, $deadhero,
    '', $unitstraped_att,
]);
```

---

### 🔵 التغيير ب: مسار الهجوم العادي (Normal attack path)

#### ❌ الكود القديم
```php
$data2 = ''.$from['owner'].','.$from['wref'].','.$owntribe.','
         .$unitssend_att.','.$unitsdead_att.','
         .$steal[0].','.$steal[1].','.$steal[2].','.$steal[3].','.$battlepart['bounty'].','
         // ... (سطر واحد طويل جداً)
         .$info_ram.','.$info_cat.','.$info_chief.','.(isset($info_spy) ? $info_spy : '').','
         .',,'.$data['t11'].','.$dead11.','.$herosend_def.','.$deadhero.','.$unitstraped_att;
```

> ⚠️ **المشكلة:** الفولباك كان `''` (نص فارغ)، مما يولد حقلاً ناقصاً في الـ CSV
> ويُزيح جميع الأعمدة التالية بمقدار خانة واحدة — بما فيها خانة البطل.

#### ✅ الكود الجديد
```php
// Build report CSV — normal attack path (with looted resources)
$spy_info = isset($info_spy) ? $info_spy : ',';
$data2 = implode(',', [
    $from['owner'], $from['wref'], $owntribe,
    $unitssend_att, $unitsdead_att,
    $steal[0], $steal[1], $steal[2], $steal[3], $battlepart['bounty'],
    $to['owner'], $to['wref'], addslashes($to['name']),
    '', '', '',                              // reserved fields
    $targettribe,
    $unitssend_def[0], $unitsdead_def[0], $rom,
    $unitssend_def[1], $unitsdead_def[1], $ger,
    $unitssend_def[2], $unitsdead_def[2], $gal,
    $unitssend_def[3], $unitsdead_def[3], $nat,
    $unitssend_def[4], $unitsdead_def[4], $natar,
    $unitssend_def[5], $unitsdead_def[5],
    $DefenderHeroesTot, $DefenderHeroesDead,
    $info_ram, $info_cat, $info_chief, $spy_info,
    $data['t11'], $dead11,
    $herosend_def, $deadhero,
    $unitstraped_att,
]);
```

### 🔍 سبب المشكلة
الملف `Automation.php` يولّد بيانات التقرير على شكل سطر CSV (قيم مفصولة بفواصل).
كل حقل في هذا السطر له رقم ترتيبي ثابت، والواجهة الأمامية تقرأ الأعمدة بناءً على الترتيب.
حين يغيب `$info_spy` كان يُكتب حقل ناقص فيتحول ترتيب كل الأعمدة التالية.
النتيجة: عمود البطل `[178]` كان يُقرأ بيانات من خانة خاطئة فيظهر فارغاً أو صفراً.

### ✔️ ماذا فعل الإصلاح
تغيير الفولباك من `''` (نص فارغ يُسبب إزاحة) إلى `','` (فاصلة تحافظ على عدد الحقول ثابتاً).
هذا الإصلاح يضمن أن عمود البطل يبقى في موضعه الصحيح `[178]` في جميع الأحوال.

---

## ملخص جميع التغييرات

| الملف | السطر التقريبي | نوع التغيير | النتيجة |
|-------|---------------|------------|---------|
| `Battle.php` | ~619 | إضافة حارس null-check | البطل لا يموت في الواحات الفارغة |
| `Automation.php` | ~1301 | إضافة قيمة افتراضية لـ `$hero_pic` | رسائل البطل تظهر دائماً |
| `Automation.php` | ~2255 | إصلاح فولباك `$info_spy` في مسار الاستكشاف | عمود البطل في مكانه الصحيح |
| `Automation.php` | ~2264 | إصلاح فولباك `$info_spy` في مسار الهجوم العادي | عمود البطل في مكانه الصحيح |

---

## ✅ نتائج الاختبار

تم اختبار الإصلاحات على بيئة إنتاجية كاملة:
- ✅ البطل يعيش بعد مهاجمة واحة فارغة (خسائر = 0)
- ✅ عمود ⭐ يظهر بشكل صحيح مع جيش مكوّن من 10 جنود + بطل
- ✅ رسالة "Your hero had nothing to kill therefore gains no XP at all" تظهر في قسم المعلومات
- ✅ لا تشفيت في أعمدة التقرير

---

*تم الإصلاح بواسطة فريق التطوير — مايو 2026*
