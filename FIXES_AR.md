# تقرير إصلاح الأخطاء — فرع testing

> **المشروع:** TravianZ  
> **الفرع:** testing  
> **الملفات المعدّلة:** `GameEngine/Database.php` — `GameEngine/Artifacts.php` — `GameEngine/Automation.php` — `GameEngine/Building.php` — `GameEngine/Units.php` — `GameEngine/Lang/` — `Templates/Build/` — `Templates/multivillage.tpl` — `Templates/Map/vilview.tpl` — `install/data/constant_format.tpl`  
> **تاريخ الإصلاح:** يونيو 2026

---

## نظرة عامة

تم اكتشاف وإصلاح **تسعة أخطاء** موزعة على منظومتين: قائمة البناء (Travian Plus / مهندس البناء)، ومنظومة توليد قرى التاتار والتحف. بعض هذه الأخطاء كانت تتسبب في تجميد السيرفر أو توليد عشرات الآلاف من القرى المكررة، وبعضها كان يمنع ظهور التحف والمخططات كليًا. فيما يلي شرح تفصيلي لكل خطأ وطريقة إصلاحه.

إضافةً إلى ذلك، تم تطوير **ميزة جديدة كاملة** لنهاية اللعبة: *البناء ثنائي الطبقات لمعجزة العالم وساعة التتار* — موثّقة بالتفصيل في **القسم الثالث**.

---

---

## قسم أول — أخطاء قائمة البناء (Travian Plus / مهندس البناء)

---

## الخطأ الأول — عدم اختفاء تسمية "قائمة الانتظار" بعد انتهاء البناء الأساسي

### المشكلة
عند وجود بناء في قائمة انتظار `loopcon=1` (Travian Plus)، وبعد انتهاء البناء الأساسي، يُفترض أن يتحول هذا البناء **تلقائيًا** إلى بناء أساسي نشط (`loopcon=0`) وتختفي تسمية "قائمة الانتظار". لكن ما كان يحدث هو:

- الكود القديم كان يرفّع **جميع** مهام `loopcon=1` دفعةً واحدة بشرط `timestamp <= now`
- هذا يعني أن مهمة كانت مجدولة لوقت لاحق قد تُرفَّع قبل أوانها
- والأهم: التسمية `WAITING` (قائمة الانتظار) كانت تبقى ظاهرة في الواجهة بسبب احتساب خاطئ لحالة المهام

### الإصلاح
تم تغيير منطق الترفيع في `Automation.php` ليختار **المهمة التالية فقط** بحسب أقل `timestamp`:

```php
// قبل الإصلاح — ترفيع جماعي خاطئ
UPDATE bdata SET loopcon = 0
WHERE loopcon = 1 AND master = 0 AND timestamp <= $time AND wid = $villageId

// بعد الإصلاح — ترفيع المهمة التالية واحدة فقط
SELECT id FROM bdata
WHERE loopcon = 1 AND master = 0 AND wid = $villageId
ORDER BY timestamp ASC LIMIT 1
→ UPDATE bdata SET loopcon = 0 WHERE id = $nextJobId
```

---

## الخطأ الثاني — أرقام المستويات الفوضوية في واجهة البناء

### المشكلة
عند وجود مهام في قائمة الانتظار (`loopcon=1`) أو مهندس البناء (`master=1`)، كانت أرقام المستويات المعروضة في الواجهة **غير دقيقة**. مثال:

| الحالة الفعلية | ما كان يظهر | ما يجب أن يظهر |
|---|---|---|
| بُني مستوى 2، انتظار مستوى 3، مهندس مستوى 4 | "ترقية إلى مستوى 3" | "ترقية إلى مستوى 5" |

**السبب التقني:**  
كانت القوالب تستخدم `isCurrent()` و`isLoop()` اللتين تعيدان قيمة ثنائية (0 أو 1) فقط:

```php
// قبل الإصلاح — قيمة ثنائية لا تحتسب عدد المهام
$loopsame = ($building->isCurrent($id) || $building->isLoop($id)) ? 1 : 0;
$doublebuild = ($building->isCurrent($id) && $building->isLoop($id)) ? 1 : 0;
// معادلة المستوى المعروض: currentLevel + (loopsame > 0 ? 2 : 1)
// النتيجة: دائمًا +1 أو +2 بغض النظر عن عدد المهام
```

وكان هناك كود تعويضي خاطئ يزيد الفوضى:
```php
// كود خاطئ تم حذفه
if ($master == 1 && $loopsame == 1) $loopsame = 0;
```

### الإصلاح
تم استبدال الحسابات الثنائية بعدّ فعلي للمهام في جميع قوالب البناء (`upgrade.tpl`, `next.tpl`, `availupgrade.tpl`, `wwupgrade.tpl`):

```php
// بعد الإصلاح — عدّ حقيقي لجميع المهام
$loopsame = count($database->getBuildingByField($village->wid, $id));  // مهام active + loopcon
$master   = count($database->getMasterJobsByField($village->wid, $id)); // مهام master=1

// معادلة المستوى المعروض: currentLevel + 1 + $loopsame + $master
// النتيجة: صحيحة دائمًا بغض النظر عن عدد المهام
```

وتم إضافة دالتين جديدتين في `Database.php` لقراءة المهام من الكاش:

```php
// المهام النشطة وقائمة الانتظار (master=0)
function getBuildingByField($wid, $field): array

// مهام مهندس البناء (master=1)
function getMasterJobsByField($wid, $field): array
```

---

## الخطأ الثالث — انهيار Automation عند فشل أي طريقة واحدة

### المشكلة
دورة Automation تُشغّل عشرات الطرق (buildComplete, spawnNatars, trainingComplete...). الكود القديم كان يستدعيها **بدون أي حماية**، فإذا فشلت طريقة واحدة بسبب خطأ PHP أو استثناء في قاعدة البيانات، كانت **كل الطرق التالية تتوقف** تمامًا في تلك الدورة.

### الإصلاح
تم تغليف كل طريقة في `Automation.php` بـ `try/catch` مع تسجيل الخطأ والمتابعة:

```php
// بعد الإصلاح — عزل كل طريقة عن الأخرى
try {
    call_user_func(array($this, $method));
} catch (\Throwable $e) {
    error_log("Automation method '$method' failed: " . $e->getMessage());
} finally {
    flock($file, LOCK_UN);
}
```

---

## قسم ثانٍ — أخطاء منظومة التاتار والتحف

---

## الخطأ الأول — الحلقة اللانهائية في `generateBase`

### المشكلة
عند محاولة إنشاء قرى التاتار أو قرى المعجزة، تبحث الدالة `generateBase` عن خلايا فارغة في الخريطة ضمن نطاق معين. إذا كانت الخلايا في ذلك النطاق **ممتلئة بالكامل**، كانت الدالة تدخل في حلقة `while` لا تنتهي أبدًا، مما يتسبب في:

- تجميد السيرفر تمامًا (HTTP 504 Timeout)
- استنزاف موارد الخادم
- توليد عشرات الآلاف من القرى الفاسدة (`wref = 0`) في قاعدة البيانات

**السبب التقني:**  
الكود القديم كان يزيد المتغير `$count` فقط في الوضع `mode=0` (قرى اللاعبين العاديين). أما في أوضاع التحف (`mode=2,3,4,5`)، كان `$count` لا يتغير أبدًا، فتستمر الحلقة في تنفيذ نفس الاستعلام الفاشل بلا توقف.

### الإصلاح
تم إضافة شرط `break` فوري عند عدم وجود خلايا متاحة في أي وضع غير `mode=0`:

```php
if ($resultedRows == 0) {
    if ($mode == 0 && $count < WORLD_MAX * 2) { $count++; continue; }
    break; // ← الإصلاح: الخروج فورًا بدل الدوران للأبد
}
```

كما تم إضافة تهيئة `$wids = []` قبل حلقة `foreach` لتفادي تحذير PHP 8.3 عند عدم وجود نتائج.

---

## الخطأ الثاني — تعارض نوع مخططات بناء المعجزة

### المشكلة
مخططات البناء (الصحائف/Scrolls) كانت تُحفظ في قاعدة البيانات بـ `type=11`، وهو **نفس رقم تحف المدافع (Defender)**. هذا تسبب في:

- دالة `areArtifactsSpawned(true)` تعود بـ `true` بمجرد وجود أي تحف مدافع
- إيهام النظام بأن المخططات تم إنشاؤها مسبقًا
- **عدم ظهور مخططات البناء في اللعبة نهائيًا**

### الإصلاح
تم تغيير نوع مخططات البناء إلى `type=15` وهو رقم خاص بها لا يتعارض مع أي تحفة أخرى:

```php
// قبل الإصلاح
['type' => 11, 'name' => 'WW Building Plans', ...]

// بعد الإصلاح
['type' => 15, 'name' => 'WW Building Plans', ...]
```

وتم تحديث دالة `areArtifactsSpawned()` لتقبل معامل `$mode`:

```php
// التحقق من التحف العادية
areArtifactsSpawned()          // SELECT 1 FROM artefacts

// التحقق من مخططات البناء فقط
areArtifactsSpawned(true)      // SELECT 1 FROM artefacts WHERE type=15
```

---

## الخطأ الثالث — حلقة حذف-إنشاء قرى المعجزة

### المشكلة
دالة `createWWVillages()` كانت تحذف قرى المعجزة الموجودة **قبل** إنشاء قرى جديدة. هذا النمط الخطير تسبب في:

1. يُحذف الكود القرى الموجودة من `vdata`
2. تفشل عملية إنشاء القرى الجديدة لأي سبب
3. دالة `areWWVillagesSpawned()` تعود بـ `false` (لا توجد قرى)
4. في الدورة التالية لـ Automation يعيد الكود الحذف والمحاولة... إلى ما لا نهاية

**النتيجة:** حلقة لا تنتهي في كل دورة Automation تُجمّد السيرفر وتُفسد قاعدة البيانات.

### الإصلاح
تم **حذف كتلة الحذف بالكامل** من `createWWVillages()`. دالة `spawnWWVillages()` في `Automation.php` تتحقق مسبقًا من `areWWVillagesSpawned()` قبل استدعاء `createWWVillages()`، فلا حاجة إطلاقًا للحذف داخل دالة الإنشاء:

```php
// قبل الإصلاح — كتلة خطيرة تم إزالتها
$existing = $database->getWWVillages();
foreach ($existing as $wid) {
    $database->DelVillage($wid); // ← حذف قبل الإنشاء = كارثة
}

// بعد الإصلاح — إنشاء مباشر بدون حذف
// spawnWWVillages() تتحقق من areWWVillagesSpawned() قبل الاستدعاء
// فلا يمكن للقرى أن تكون موجودة هنا أصلًا
```

---

## الخطأ الرابع — غياب حماية حساب التاتار (uid=3)

### المشكلة
دالة `createNatars()` كانت تفتقر إلى فحص كافٍ للتحقق مما إذا كان حساب التاتار (`uid=3`) موجودًا بالفعل. في بعض السيناريوهات، كان النظام يحاول تسجيل حساب جديد برقم `3` وهو موجود أصلًا، مما يسبب أخطاء في قاعدة البيانات.

### الإصلاح
تم إعادة هيكلة `createNatars()` بحيث:

1. **إذا لم يكن `uid=3` موجودًا:** يُسجَّل الحساب، ثم تُنشأ القرى والتحف
2. **إذا كان `uid=3` موجودًا لكن لا توجد تحف:** يتخطى التسجيل ويُنشئ التحف والقرى مباشرةً
3. **إذا كانت التحف موجودة بالفعل:** لا يفعل شيئًا (`areArtifactsSpawned()` تمنعه)

كما تم إزالة استدعاءات `getVilWrefs()` و`getFreeVillage()` الزائدة التي لا معنى لها عند إعادة التوليد.

---

## الخطأ الخامس — تكرار اختيار نفس الخلية في `generateVillages`

### المشكلة
هذا الخطأ كان خفيًا ويظهر بشكل عشوائي. دالة `generateVillages()` تستدعي `generateBase()` عدة مرات — مرة لكل مجموعة من القرى (حسب الوضع والقطاع). المشكلة كانت أن:

- `generateBase` تعيد الخلايا المتاحة بناءً على `occupied=0` في قاعدة البيانات
- **لا يتم تحديث `occupied=1` إلا في نهاية العملية كلها** (في `setFieldTaken`)
- بعض نطاقات الأوضاع **تتداخل جغرافيًا**:
  - `mode=4` (التحف الفريدة): 5%–20% من نصف القطر
  - `mode=2` (التحف الصغيرة): 10%–30% من نصف القطر
  - المنطقة 10%–20% مشتركة بين الوضعين!
- نتيجة ذلك: استدعاءان مختلفان لـ `generateBase` يختاران **نفس الخلية**
- عند محاولة إدراج القرية مرتين → **Duplicate entry error** في قاعدة البيانات

**الأثر:** يظهر الخطأ بشكل غير منتظم (حسب `ORDER BY RAND()`)، مما جعل تشخيصه صعبًا جدًا.

### الإصلاح
تم إضافة معامل `$alreadySelected` لدالة `generateBase` ومتغير `$globallyPickedWids` في `generateVillages` لتتبع الخلايا المختارة عبر جميع الاستدعاءات:

```php
// في generateBase — تهيئة قائمة الاستبعاد بالخلايا المختارة مسبقًا
$selectedIds = array_map('intval', $alreadySelected);

// في generateVillages — تراكم الخلايا المختارة بين الاستدعاءات
$globallyPickedWids = [];
foreach ($countedWids as $mode => $totalCount) {
    foreach ($totalCount as $sector => $count) {
        $generatedWids = $this->generateBase($sector, $mode, $count, $globallyPickedWids);
        $globallyPickedWids = array_merge($globallyPickedWids, $generatedWids); // ← الإصلاح
        $wids[$mode] = array_merge($wids[$mode] ?? [], $generatedWids);
    }
}
```

---

## الخطأ السادس — مخطط البناء يُحتسب ضمن حد التحف العادية

### المشكلة
نظام التحف يفرض على كل لاعب حدًا أقصى:
- **تحفتان صغيرتان** (size=1)
- **تحفة واحدة كبيرة أو نادرة** (size=2 أو 3)
- **مخطط بناء واحد** (type=15) — مستقل تمامًا عن الحد أعلاه

لكن دالة `getOwnArtifactsSum()` في `Database.php` كانت تُضمّن `type=15` في الحساب الإجمالي:

```sql
-- قبل الإصلاح — يعد مخطط البناء كتحفة صغيرة
SELECT Count(size) AS totals, SUM(IF(size='1',1,0)) small, ...
FROM artefacts WHERE owner = $uid
```

**النتيجة:** إذا احتل اللاعب مخطط بناء (type=15)، يُحتسب في `totals` كتحفة صغيرة — فيُصبح قادرًا على احتلال تحفة واحدة صغيرة وتحفة كبيرة فقط، بدلًا من اثنتين صغيرتين وكبيرة. أي أن مخطط البناء **يسرق** فتحة من التحف العادية.

كذلك كانت دالة `canClaimArtifact()` تستخدم نفس العداد المدمج، فلم تكن تتحقق من حد مخطط البناء (1 فقط) بشكل مستقل.

### الإصلاح
**أولًا:** استثناء `type=15` من `getOwnArtifactsSum` بإضافة `AND type != 15`:

```sql
-- بعد الإصلاح — مخطط البناء مستثنى تمامًا
SELECT Count(size) AS totals, SUM(IF(size='1',1,0)) small, ...
FROM artefacts WHERE owner = $uid AND type != 15
```

**ثانيًا:** إضافة فحص مستقل في `canClaimArtifact()` لمخطط البناء عبر `getWWConstructionPlans()`:

```php
// بعد الإصلاح — فحص منفصل لمخططات البناء
if ($type == 15) {
    $plans = $this->getWWConstructionPlans($uid);
    if ((int)($plans[0]['Total'] ?? 0) >= 1 && $uid != $vuid) {
        return "Max num. of building plans. Your hero could not claim the artefact";
    }
}
// ثم الفحص العادي للتحف (بدون type=15)
$artifact = $this->getOwnArtifactsSum($uid); // type=15 مستثنى
if ($artifact['totals'] < 3 || ...) { ... }
```

**النتيجة النهائية:**
| الحد | قبل الإصلاح | بعد الإصلاح |
|---|---|---|
| تحف صغيرة | 2 (تُنقص إذا احتل مخططًا) | 2 دائمًا ✅ |
| تحفة كبيرة/نادرة | 1 | 1 ✅ |
| مخطط بناء | لا حد مستقل | 1 مستقل ✅ |
| المجموع | 3 (خطأ) | 4 (صحيح) ✅ |

---

## إصلاح إضافي — ملف التثبيت `config.tpl`

تم إضافة ثابت `NATARS_WW_BUILD_INTERVAL` إلى قالب الإعدادات ليُحسب تلقائيًا عند التثبيت:

```php
define("NATARS_WW_BUILD_INTERVAL", (int) max(60, round(86400 / max(1, (int) SPEED))));
```

هذا يضمن أن التاتار يبني مستوى واحدًا من المعجزة كل `86400 ÷ SPEED` ثانية — أي في سيرفر بسرعة 100، كل 14 دقيقة تقريبًا.

> **ملاحظة:** أُعيد ضبط هذا الثابت لاحقًا ضمن ميزة "البناء ثنائي الطبقات" (انظر القسم الثالث، الفقرة 5) ليُحسب على أساس نافذة 72 ساعة من وقت اللعبة بدلًا من 24 ساعة.

---

# قسم ثالث — ميزة البناء ثنائي الطبقات لمعجزة العالم وساعة التتار (نهاية اللعبة)

---

## نظرة عامة على الميزة

هذه **ميزة جديدة** (وليست إصلاح خطأ) تحوّل مرحلة نهاية اللعبة (بناء معجزة العالم) إلى سباق من مرحلتين ضد عدّاد زمني صارم تتحكم فيه قبائل التتار. تتكوّن الميزة من:

1. **طبقتان للمخططات:** مخطط صغير (`type=15`) للمستويات 1–50، ومخطط كبير (`type=16`) للمستويات 51–100، مع إجبار اللاعب على **تبديل** المخطط عند المستوى 50.
2. **معجزة التتار المحمية** (`معجزة التتار`): قرية معجزة واحدة محصّنة تمامًا لا يمكن مهاجمتها ولا احتلالها، يبنيها التتار تلقائيًا من المستوى 0 إلى 100 كعدّاد تنازلي ينهي السيرفر.
3. **قرية معجزة واحدة لكل لاعب:** لا يمكن للاعب احتلال أكثر من قرية معجزة واحدة من القرى الـ 12 القابلة للاحتلال.

---

## 1. طبقتان لمخططات البناء — مخطط صغير (`type=15`) ومخطط كبير (`type=16`)

### الحاجة
كان النظام السابق يحتوي على **طبقة واحدة فقط** من المخططات (`type=15`)، وكان شرط البناء فوق المستوى 50 هو امتلاك التحالف لمخططين. الميزة الجديدة تقسم المخططات إلى طبقتين منفصلتين.

### التنفيذ
في `GameEngine/Artifacts.php`، تم تغيير ثابت `NATARS_WW_BUILDING_PLANS` من 12 مخططًا صغيرًا إلى **6 صغيرة + 6 كبيرة**:

```php
// قبل — 12 مخطط صغير فقط
NATARS_WW_BUILDING_PLANS = [PLAN_DESC => [["type" => 15, ... "quantity" => 12, ...]]],

// بعد — 6 صغيرة + 6 كبيرة
NATARS_WW_BUILDING_PLANS = [
    PLAN_DESC       => [["type" => 15, "name" => PLAN,       "vname" => PLANVILLAGE,       "quantity" => 6, ...]],
    PLAN_LARGE_DESC => [["type" => 16, "name" => PLAN_LARGE,  "vname" => PLANVILLAGE_LARGE,  "quantity" => 6, ...]],
];
```

وتمت إضافة نصوص اللغة الجديدة في `GameEngine/Lang/en.php` و`GameEngine/Lang/ar/part4.php`:

| الثابت | العربية |
|---|---|
| `PLAN` | مخطط بناء معجزة صغير |
| `PLANVILLAGE` | قرية مخطط بناء صغير |
| `PLAN_LARGE` | مخطط بناء معجزة كبير |
| `PLANVILLAGE_LARGE` | قرية مخطط بناء كبير |
| `NATARWONDER` | معجزة التتار |

---

## 2. بوابة ترقية المعجزة — نموذج التبديل (`Building.php`)

### المشكلة
كانت دالة `allowWwUpgrade()` تعتمد على قاعدة التحالف القديمة (مخطط للاعب + مخطط للتحالف للمستويات فوق 50)، وهي لا تتوافق مع نظام الطبقتين.

### الإصلاح
تم استبدال القاعدة بالكامل بنموذج **التبديل**: المخطط الصغير يبني حتى المستوى 50، والمخطط الكبير يبني من 51 إلى 100 **بشرط ألا يكون اللاعب لا يزال يملك مخططًا صغيرًا**:

```php
// بعد الإصلاح — نموذج التبديل
$userHasSmallPlan = $database->getWWConstructionPlans($session->uid, 0, 15);
$userHasLargePlan = $database->getWWConstructionPlans($session->uid, 0, 16);

if($wwHighestLevelFound < 50) $cached = $userHasSmallPlan;          // 1–50 → مخطط صغير
else                          $cached = $userHasLargePlan && !$userHasSmallPlan; // 51+ → كبير وليس صغير
```

كما أُضيف معامل ثالث `$planType` لدالة `getWWConstructionPlans($uid, $alliance, $planType=15)` ليمكن الاستعلام عن كل طبقة على حدة.

**إنفاذ فقدان المخطط أثناء البناء:** أُضيف فحص في `buildComplete()` (في `Automation.php`) يمنع ترقية مستوى المعجزة إذا فقد المالك المخطط المطلوب أثناء وجود المهمة في الطابور (تبقى المهمة في الطابور وتُستأنف تلقائيًا عند استعادة المخطط؛ والتتار مستثنون):

```php
if ($indi['type'] == 40 && (int) $villageOwner != Artifacts::NATARS_UID) {
    $targetLevel = (int) $indi['level'];
    $hasSmall = $database->getWWConstructionPlans($villageOwner, 0, 15);
    $hasLarge = $database->getWWConstructionPlans($villageOwner, 0, 16);
    $planOk = ($targetLevel <= 50) ? $hasSmall : ($hasLarge && !$hasSmall);
    if (!$planOk) continue; // تخطّي الترقية مع إبقاء المهمة في الطابور
}
```

---

## 3. معجزة التتار المحمية — قرية لا يمكن مهاجمتها ولا احتلالها

### التنفيذ
عند توليد قرى المعجزات (`createWWVillages()` في `Artifacts.php`)، تُسمّى **آخر قرية** باسم `NATARWONDER` (معجزة التتار) وتبقى مملوكة للتتار `natar=1` دائمًا، بينما تبقى الـ 12 الأخرى باسم `WWVILLAGE` قابلة للاحتلال:

```php
$villageName = ($i == $numberOfVillages) ? NATARWONDER : WWVILLAGE; // آخر قرية = المعجزة المحمية
```

أُضيفت دالة مركزية في `Database.php` تُعرّف القرية المحمية بثلاثة شروط معًا (المالك + علم المعجزة + الاسم):

```php
function isProtectedNatarWonder($wref){
    $q = "SELECT 1 FROM ".TB_PREFIX."vdata
          WHERE wref = ".$wref."
            AND owner = ".Artifacts::NATARS_UID."
            AND natar = 1
            AND name = '".mysqli_real_escape_string($this->dblink, NATARWONDER)."' LIMIT 1";
    return mysqli_num_rows(mysqli_query($this->dblink, $q)) > 0;
}
```

تُستخدم هذه الدالة في **ثلاثة مواضع** لمنع أي استهداف:

1. **منع الهجوم المباشر** — في `Units.php` (`sendTroops`)، يُرفض الإرسال برسالة خطأ قبل إنشاء أي حركة:
   ```php
   if(!$isOasisTarget && $database->isProtectedNatarWonder($targetVid)) {
       $form->addError("error", "لا يمكن مهاجمة معجزة التتار، فهي محمية تماماً ولا يمكن احتلالها.");
   }
   ```
2. **منع الإغارة عبر قوائم الإغارة** (Farm List) — نفس الفحص في حلقة معالجة قوائم الإغارة في `Units.php`.
3. **منع الاحتلال** — في كتلة الاحتلال في `Automation.php`، يُضبط `$nochiefing = 1` إذا كانت القرية هي معجزة التتار.

---

## 4. قرية معجزة واحدة لكل لاعب

### التنفيذ
أُضيفت دالة `countOwnedWWVillages($uid)` في `Database.php`:

```php
function countOwnedWWVillages($uid){
    $q = "SELECT Count(*) as Total FROM ".TB_PREFIX."vdata WHERE owner = ".$uid." AND natar = 1";
    return (int) mysqli_fetch_array(mysqli_query($this->dblink, $q), MYSQLI_ASSOC)['Total'];
}
```

وفي كتلة الاحتلال في `Automation.php`، يُمنع احتلال قرية معجزة ثانية إذا كان المهاجم يملك واحدة بالفعل:

```php
if(!isset($nochiefing) && $to['natar'] == 1 && $database->countOwnedWWVillages($from['owner']) >= 1){
    $nochiefing = 1;
    $info_chief = "".$chief_pic.",لا يمكنك امتلاك أكثر من قرية معجزة واحدة.";
}
```

**حماية قرى المخططات أيضًا:** استُبدل الفحص القديم الهشّ (`$to['name'] != 'WW Buildingplan'`) — الذي كان يعتمد على اسم القرية بلغة واحدة — بفحص قائم على التحفة المملوكة وغير مرتبط باللغة عبر `isNatarPlanVillage()`:

```php
function isNatarPlanVillage($wref){
    $q = "SELECT 1 FROM ".TB_PREFIX."artefacts
          WHERE vref = ".$wref." AND owner = ".Artifacts::NATARS_UID."
            AND type IN (15, 16) AND del = 0 LIMIT 1";
    return mysqli_num_rows(mysqli_query($this->dblink, $q)) > 0;
}
```

---

## 5. ساعة التتار — العدّاد التنازلي لنهاية اللعبة (`buildNatarWW`)

### التنفيذ
**أولًا — إعادة ضبط الفاصل الزمني** في `install/data/constant_format.tpl` ليُمثّل بناء المعجزة من 0 إلى 100 خلال نافذة **72 ساعة من وقت اللعبة** (الزمن الحقيقي الكلي = 72 ساعة ÷ SPEED):

```php
// معجزة التتار ترتفع من 0 إلى 100 خلال نافذة 72 ساعة من وقت اللعبة
define("NATARS_WW_BUILD_INTERVAL", (int) max(1, round((72 * 3600) / 100 / max(1, (int) SPEED)))); // ثانية لكل مستوى
```

**ثانيًا — استهداف المعجزة المحمية فقط:** كان `buildNatarWW()` يختار أي قرية معجزة بـ `ORDER BY wref ASC LIMIT 1`، فبعد احتلال اللاعبين للقرى الأخرى قد يبني التتار قرية خاطئة. تم تعديل الاستعلام ليستهدف **معجزة التتار المحمية فقط** عبر اسمها:

```php
$q = "SELECT wref FROM ".TB_PREFIX."vdata
      WHERE owner = ".Artifacts::NATARS_UID." AND natar = 1
        AND name = '".mysqli_real_escape_string($database->dblink, NATARWONDER)."'
      ORDER BY wref ASC LIMIT 1";
```

**ثالثًا — التوافق مع الخوادم القديمة:** إذا لم توجد قرية باسم `معجزة التتار` (سيرفر أُطلق قبل الميزة)، تُرقّى تلقائيًا قرية معجزة واحدة لا تزال مملوكة للتتار إلى الحالة المحمية (مرة واحدة فقط)، بدلًا من التوقف.

---

## 6. حدود المخططات وتفعيلها

### المشكلة والإصلاح
بعد إضافة الطبقة الكبيرة (`type=16`)، توجّب تحديث منطق الحدود ليستثني **الطبقتين** معًا:

**أولًا** — استثناء كلا النوعين من حد التحف العادية في `getOwnArtifactsSum()`:
```php
// قبل: AND type != 15      →      بعد: AND type NOT IN (15, 16)
```

**ثانيًا** — في `canClaimArtifact()`، فحص مستقل لكل طبقة (يُسمح بمخطط واحد من كل نوع):
```php
if ($type == 15 || $type == 16) {
    if ($this->getWWConstructionPlans($uid, 0, $type) && $uid != $vuid) {
        return "Max num. of building plans. Your hero could not claim the artefact";
    }
}
```

**ثالثًا** — في `Artifacts.php` (تفعيل التحف)، تُفعَّل المخططات **دائمًا** بغض النظر عن حد الثلاث تحف، لأن المخطط لا يشغل فتحة تحفة. بدون هذا، لاعب يملك 3 تحف نشطة لن يستطيع أبدًا تفعيل مخطط محتل ولن يقدر على بناء المعجزة:

```php
if($artifact['type'] == 15 || $artifact['type'] == 16){
    $database->activateArtifact($artifact['id']);
    continue;
}
```

---

## 7. إعادة تسمية قرى المخططات في الواجهة (عرض فقط)

### التنفيذ
أي قرية تحمل مخطط بناء تُعرض باسم الطبقة المناسبة (صغير/كبير) **في الواجهة فقط** دون تعديل `vdata.name` (يُحفظ اسم اللاعب الحقيقي). أُضيفت دالتان في `Database.php`:

```php
villageDisplayName($wref, $rawName)      // اسم العرض لقرية واحدة
getPlanTypesByVillages($wrefs)           // استعلام مجمّع: [wref => نوع المخطط] لتفادي N+1
```

- **مبدّل القرى** (`Templates/multivillage.tpl`): يستخدم `getPlanTypesByVillages()` لجلب أنواع المخططات في استعلام واحد، ثم يعرض اسم الطبقة.
- **عرض القرية على الخريطة** (`Templates/Map/vilview.tpl`): يستخدم `villageDisplayName()`، ويعرض أيقونة المخطط للطبقتين الصغيرة والكبيرة (`PLANVILLAGE` أو `PLANVILLAGE_LARGE`).

---

## نتائج الاختبار

تم التحقق من جميع الإصلاحات عبر:

### اختبار قائمة البناء
| الاختبار | النتيجة |
|---|---|
| بناء مستوى 2، انتظار مستوى 3، مهندس مستوى 4 → الواجهة تعرض "ترقية إلى مستوى 5" | ✅ |
| بعد انتهاء البناء الأساسي، تختفي تسمية "قائمة الانتظار" وتتحول المهمة إلى نشطة | ✅ |
| مهندس البناء يُحتسب في رقم المستوى المعروض بشكل صحيح | ✅ |
| فشل طريقة واحدة في Automation لا يوقف بقية الطرق | ✅ |

### اختبار تكاملي للتاتار (37/37 اختبار ناجح)
| الاختبار | النتيجة |
|---|---|
| حساب التاتار `uid=3` موجود ولا يُعاد تسجيله | ✅ |
| إنشاء 63 قرية تحفة بشكل صحيح | ✅ |
| لا توجد قرى تاتار يتيمة بدون تحف | ✅ |
| `generateBase` يعود فورًا عند امتلاء الخريطة (< 500ms) | ✅ |
| لا حلقة لانهائية (`mode != 0`) | ✅ |
| إنشاء 12 مخطط بناء بـ `type=15` | ✅ |
| `type=11` لم يتغير (لا تداخل) | ✅ |
| `areArtifactsSpawned(true)` يمنع إعادة التشغيل | ✅ |
| `createWWVillages()` لا تحتوي على حذف قبل الإنشاء | ✅ |
| إنشاء 13 قرية معجزة بنجاح | ✅ |
| التسلسل الكامل: 63 تحفة → 75 مع مخططات → 88 مع المعجزات | ✅ |
| جميع الحراس يمنعون إعادة التشغيل بعد اكتمال كل مرحلة | ✅ |

### اختبار على السيرفر الفعلي (GCP)
| المرحلة | النتيجة |
|---|---|
| المرحلة 1 — ظهور التحف: 63 قرية تحفة | ✅ |
| المرحلة 2 — ظهور المخططات: 12 قرية مخطط | ✅ |
| المرحلة 3 — ظهور قرى المعجزة: 13 قرية، بدون تجميد | ✅ |
| العدد الكلي لقرى التاتار على ملفه الشخصي: **89 قرية** | ✅ |
| رسائل النظام العامة ظهرت لجميع اللاعبين | ✅ |

### اختبار ميزة البناء ثنائي الطبقات (آلي عبر Playwright على السيرفر الفعلي)
| الاختبار | النتيجة |
|---|---|
| مهاجمة `معجزة التتار` تُرفض برسالة "لا يمكن مهاجمة معجزة التتار..." ولا تُنشأ أي حركة | ✅ |
| ساعة التتار: مستوى المعجزة `f99` يرتفع تلقائيًا (شوهد 18 ← 19) و`f99t=40` | ✅ |
| الفاصل الزمني = `259` ثانية/مستوى = `72×3600÷100÷SPEED` (سرعة 10) | ✅ |
| بوابة الترقية — 6 سيناريوهات: صغير 1–50، كبير 51+، إجبار التبديل، حجب الاحتفاظ بالاثنين | ✅ 6/6 |
| قرية معجزة واحدة لكل لاعب: `countOwnedWWVillages` يحجب احتلال الثانية | ✅ |
| عدد المخططات المولّدة: 6 صغيرة (`type=15`) + 6 كبيرة (`type=16`) | ✅ |
| عدد قرى المعجزات: 12 قرية قابلة للاحتلال + 1 معجزة تتار محمية | ✅ |
| مبدّل القرى يعرض اسم طبقة المخطط (صغير/كبير) دون تعديل الاسم الحقيقي | ✅ |

---

## ملخص الملفات المعدّلة

| الملف | التغييرات |
|---|---|
| `GameEngine/Database.php` | إصلاح الحلقة اللانهائية، إصلاح تكرار الخلايا، إضافة `areArtifactsSpawned($mode)`، إضافة `getBuildingByField()` و`getMasterJobsByField()`، استثناء `type=15/16` من `getOwnArtifactsSum`، فحص مستقل لمخططات البناء في `canClaimArtifact`. **[الميزة]** معامل `$planType` لـ `getWWConstructionPlans`، إضافة `isProtectedNatarWonder`، `isNatarPlanVillage`، `countOwnedWWVillages`، `villageDisplayName`، `getPlanTypesByVillages` |
| `GameEngine/Artifacts.php` | إصلاح `type=15`، إزالة حذف-إنشاء WW، تحسين `createNatars()`. **[الميزة]** 6 مخططات صغيرة + 6 كبيرة، تسمية آخر قرية `NATARWONDER`، تفعيل المخططات (15/16) دائمًا بغض النظر عن حد التحف |
| `GameEngine/Automation.php` | إصلاح ترفيع loopcon (مهمة واحدة فقط)، تغليف كل طريقة بـ try/catch، إصلاح `Artifacts::NATARS_UID`. **[الميزة]** حراس الاحتلال (معجزة محمية + قرية واحدة لكل لاعب + قرى المخططات)، استهداف `buildNatarWW` للمعجزة المحمية + توافق الخوادم القديمة، فحص فقدان المخطط في `buildComplete` |
| `GameEngine/Building.php` | **[الميزة]** `allowWwUpgrade` — نموذج التبديل بين المخطط الصغير (1–50) والكبير (51+) |
| `GameEngine/Units.php` | **[الميزة]** منع مهاجمة معجزة التتار في `sendTroops` وفي قوائم الإغارة |
| `GameEngine/Lang/en.php` — `GameEngine/Lang/ar/part4.php` | **[الميزة]** نصوص `PLAN/PLANVILLAGE` (صغير) + `PLAN_LARGE/PLANVILLAGE_LARGE` (كبير) + `NATARWONDER` |
| `Templates/Build/upgrade.tpl` | إصلاح معادلة المستوى: `currentLevel + 1 + loopsame + master` |
| `Templates/Build/next.tpl` | استبدال `isCurrent/isLoop` بـ `count(getBuildingByField)` |
| `Templates/Build/avaliable/availupgrade.tpl` | نفس إصلاح next.tpl |
| `Templates/Build/wwupgrade.tpl` | نفس إصلاح upgrade.tpl للمعجزة |
| `Templates/multivillage.tpl` | **[الميزة]** عرض اسم طبقة المخطط في مبدّل القرى عبر `getPlanTypesByVillages` (عرض فقط) |
| `Templates/Map/vilview.tpl` | **[الميزة]** اسم العرض عبر `villageDisplayName` + أيقونة المخطط للطبقتين |
| `install/templates/config.tpl` | إضافة `NATARS_WW_BUILD_INTERVAL`، ضبط قيم افتراضية |
| `install/data/constant_format.tpl` | **[الميزة]** إعادة ضبط `NATARS_WW_BUILD_INTERVAL` لنافذة 72 ساعة من وقت اللعبة (`72×3600÷100÷SPEED`) |
