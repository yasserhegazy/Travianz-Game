<?php
//BUILDINGS
define('WOODCUTTER', 'الحطاب');
define('WOODCUTTER_DESC', 'يقوم الحطاب بقطع الأشجار لإنتاج الخشب. كلما قمت بتطوير الحطاب، كلما زاد إنتاج الخشب.<br>ببناء منشرة الخشب، يمكنك زيادة الإنتاج أكثر');
define('CLAYPIT', 'حفرة الطين');
define('CLAYPIT_DESC', 'هنا، يتم إنتاج الطين. من خلال رفع مستواها، تقوم بزيادة إنتاج الطين.<br>ببناء مصنع الطوب، يمكنك زيادة الإنتاج أكثر');
define('IRONMINE', 'منجم الحديد');
define('IRONMINE_DESC', 'هنا يجمع عمال المناجم مورد الحديد الثمين. من خلال رفع مستوى المنجم، تزيد من إنتاجه من الحديد.<br>ببناء مسبك الحديد، يمكنك زيادة الإنتاج أكثر');
define('CROPLAND', 'حقل القمح');
define('CROPLAND_DESC', 'يتم إنتاج طعام سكانك هنا. من خلال رفع مستوى حقل القمح، تزيد من إنتاج القمح.<br>ببناء المطحنة والمخبز، يمكنك زيادة الإنتاج أكثر');

define('SAWMILL', 'منشرة الخشب');
define('SAWMILL_DESC', 'الخشب المقطوع من قبل الحطابين يتم معالجته هنا. تزيد منشرة الخشب إنتاج الخشب في القرية. في المستوى 1، تزيد إنتاج الخشب بنسبة 5٪، وفي كل مرة تقوم بترقيتها، يزيد الإنتاج بنسبة 5٪ إضافية، لإجمالي 25٪ بعد 5 مستويات.<br>المكافأة من منشرة الخشب وجميع المباني التي توفر مكافآت للموارد تنطبق فقط على القرية التي تم بناء المبنى فيها.<br>ملاحظة أن مكافأة منشرة الخشب لا تنطبق على تأثيرات المكافآت الأخرى مثل دخل الواحات أو مكافأة بلس 10٪.<br>هناك أيضا قرى تتكون من 3 أو 5 حقول خشب.');
define('CURRENT_WOOD_BONUS', 'مكافأة الخشب الحالية:');
define('WOOD_BONUS_LEVEL', 'مكافأة الخشب في المستوى');
define('MAX_LEVEL', 'المبنى في أعلى مستوى');
define('PERCENT', 'في المئة');

define('BRICKYARD', 'مصنع الطوب');
define('CURRENT_CLAY_BONUS', 'مكافأة الطين الحالية:');
define('CLAY_BONUS_LEVEL', 'مكافأة الطين في المستوى');
define('BRICKYARD_DESC', 'الطين يتحول إلى طوب هنا. يزيد مصنع الطوب من إنتاج الطين في القرية. في المستوى 1، يزيد الإنتاج بنسبة 5٪، وفي كل مرة تقوم بتطويره، يزيد بنسبة 5٪ أخرى، بإجمالي 25٪.<br>تنطبق المكافآت فقط على القرية الحالية.');

define('IRONFOUNDRY', 'مسبك الحديد');
define('CURRENT_IRON_BONUS', 'مكافأة الحديد الحالية:');
define('IRON_BONUS_LEVEL', 'مكافأة الحديد في المستوى');
define('IRONFOUNDRY_DESC', 'يُصهر الحديد هنا. يزيد مسبك الحديد من إنتاج الحديد في القرية بنسبة 5٪ لكل مستوى.');

define('GRAINMILL', 'المطحنة');
define('CURRENT_CROP_BONUS', 'مكافأة القمح الحالية:');
define('CROP_BONUS_LEVEL', 'مكافأة القمح في المستوى');
define('GRAINMILL_DESC', 'تُطحن الحبوب لتصبح دقيقاً هنا. تزيد المطحنة إنتاج القمح بنسبة 5٪ لكل مستوى. يمكن استخدامها مع المخبز لزيادة تصل إلى 50٪.');

define('BAKERY', 'المخبز');
define('BAKERY_DESC', 'يُخبز الخبز من الدقيق هنا. يزيد المخبز إنتاج القمح بنسبة 5٪ لكل مستوى حتى 25٪.');

define('WAREHOUSE', 'المخزن');
define('CURRENT_CAPACITY', 'السعة الحالية:');
define('CAPACITY_LEVEL', 'السعة في المستوى');
define('RESOURCE_UNITS', 'وحدات الموارد');
define('WAREHOUSE_DESC', 'يتم تخزين الخشب، الطين والحديد في المخزن. كلما رفعت مستواه، تزيد سعته.');

define('GRANARY', 'مخزن الحبوب');
define('CROP_UNITS', 'وحدات القمح');
define('GRANARY_DESC', 'يتم تخزين القمح هنا. كلما رفعت مستواه زادت قدرته الاستيعابية.');

define('BLACKSMITH', 'الحداد');
define('ACTION', 'الإجراء');
define('UPGRADE', 'تطوير');
define('UPGRADE_IN_PROGRESS', 'التطوير<br>قيد التنفيذ');
define('UPGRADE_BLACKSMITH', 'تطوير<br>الحداد');
define('UPGRADES_COMMENCE_BLACKSMITH', 'يمكن أن تبدأ الترقيات عندما يكتمل بناء الحداد.');
define('MAXIMUM_LEVEL', 'أعلى<br>مستوى');
define('EXPAND_WAREHOUSE', 'توسيع<br>المخزن');
define('EXPAND_GRANARY', 'توسيع<br>مخزن الحبوب');
define('ENOUGH_RESOURCES', 'موارد كافية');
define('CROP_NEGATIVE ', 'إنتاج القمح سالب لذلك لن تصل إلى الموارد المطلوبة أبداً');
define('TOO_FEW_RESOURCES', 'موارد<br>غير كافية');
define('UPGRADING', 'قيد التطوير');
define('DURATION', 'المدة');
define('COMPLETE', 'مكتمل');
define('BLACKSMITH_DESC', 'يتم تعزيز أسلحة محاربيك في أفران الحداد. برفع مستواه يمكنك تصنيع أسلحة أفضل');

define('ARMOURY', 'مستودع الأسلحة');
define('UPGRADE_ARMOURY', 'تطوير<br>المستودع');
define('UPGRADES_COMMENCE_ARMOURY', 'يمكن بدء الترقيات عند اكتمال المستودع.');
define('ARMOURY_DESC', 'يتم تعزيز دروع محاربيك هنا.');

define('TOURNAMENTSQUARE', 'ساحة البطولة');
define('CURRENT_SPEED', 'مكافأة السرعة الحالية:');
define('SPEED_LEVEL', 'مكافأة السرعة في المستوى');
define('TOURNAMENTSQUARE_DESC', 'الجيوش يمكنها تحسين قدرتها البدنية هنا. وتزداد سرعتها بعد عبور مسافة معينة.');

define('MAINBUILDING', 'المبنى الرئيسي');
define('CURRENT_CONSTRUCTION_TIME', 'وقت البناء الحالي:');
define('CONSTRUCTION_TIME_LEVEL', 'وقت البناء في المستوى');
define('DEMOLITION_BUILDING', 'هدم المبنى:</h2><p>إذا لم تعد بحاجة لمبنى، يمكنك هدمه.</p>');
define('DEMOLISH', 'هدم');
define('DEMOLITION_OF', 'هدم ');
define('MAINBUILDING_DESC', 'يعيش عمال البناء الرئيسيين في قريتك هنا. كلما كان المستوى أعلى كلما أسرعوا في إكمال البناء.');

define('RALLYPOINT', 'نقطة التجمع');
define('RALLYPOINT_COMMENCE', 'سيتم عرض تحركات القوات عندما يتم اكتمال '.RALLYPOINT.'');
define('OVERVIEW', 'نظرة عامة');
define('REINFORCEMENT', 'تعزيز');
define('EVASION_SETTINGS', 'إعدادات الهروب');
define('SEND_TROOPS_AWAY_MAX', 'إرسال القوات بعيداً بحد أقصى');
define('TIMES', 'مرات');
define('PER_EVASION', 'لكل هروب');
define('RALLYPOINT_DESC', 'تتجمع قوات قريتك هنا. من هنا يمكنك إرسالهم للنهب أو الهجوم أو التعزيز.');
define('COMBAT_SIMULATOR', 'محاكي المعارك');

define('MARKETPLACE', 'السوق');
define('MERCHANT', 'التجار');
define('OR_', 'أو');
define('GO', 'اذهب');
define('UNITS_OF_RESOURCE', 'وحدة من الموارد');
define('MERCHANT_CARRY', 'كل تاجر يمكنه حمل');
define('MERCHANT_COMING', 'التجار القادمون');
define('TRANSPORT_FROM', 'نقل من');
define('ARRIVAL_IN', 'الوصول خلال');
define('NO_COORDINATES_SELECTED', 'لم يتم تحديد إحداثيات');
define('CANNOT_SEND_RESOURCES', 'لا يمكنك إرسال موارد لنفس القرية');
define('BANNED_CANNOT_SEND_RESOURCES', 'اللاعب محظور. لا يمكنك الإرسال إليه');
define('RESOURCES_NO_SELECTED', 'لم يتم اختيار الموارد');
define('ENTER_COORDINATES', 'أدخل الإحداثيات أو اسم القرية');
define('TOO_FEW_MERCHANTS', 'تجار غير كافيين');
define('OWN_MERCHANTS_ONWAY', 'تجارك في الطريق');
define('MERCHANTS_RETURNING', 'التجار العائدون');
define('TRANSPORT_TO', 'نقل إلى');
define('I_AN_SEARCHING', 'أنا أبحث عن');
define('I_AN_OFFERING', 'أنا أعرض');
define('OFFERS_MARKETPLACE', 'العروض في السوق');
define('NO_AVAILABLE_OFFERS', 'لا توجد عروض في السوق');
define('OFFERED_TO_ME', 'المعروضة<br>لي');
define('WANTED_TO_ME', 'المطلوبة<br>مني');
define('NOT_ENOUGH_MERCHANTS', 'لا يوجد تجار كافيين');
define('ACCEP_OFFER', 'قبول العرض');
define('NO_AVALIBLE_OFFERS', 'لا توجد عروض متاحة في السوق');
define('SEARCHING', 'أبحث عن');
define('OFFERING', 'أعرض');
define('MAX_TIME_TRANSPORT', 'أقصى وقت للنقل');
define('OWN_ALLIANCE_ONLY', 'تحالفي فقط');
define('INVALID_OFFER', 'عرض غير صالح');
define('INVALID_MERCHANTS_REPETITION', 'تكرار غير صالح للتجار');
define('USER_ON_VACATION', 'اللاعب في وضع الإجازة');
define('VACATION_MODE', 'وضع الإجازة');
define('VACATION_DESC', 'وصف وضع الإجازة');
define('VACATION_DESC2', 'استخدم وضع الإجازة لحماية قريتك');
define('VAC_OP1', 'إرسال أو استقبال القوات');
define('VAC_OP2', 'بدء بناء جديد');
define('VAC_OP3', 'استخدام السوق');
define('VAC_OP4', 'تدريب قوات جديدة');
define('VAC_OP5', 'الانضمام لتحالف');
define('VAC_OP6', 'حذف الحساب');
define('VAC_COND1', 'لا توجد قوات في حركة');
define('VAC_COND2', 'لا توجد قوات في طريقها لقرى أخرى');
define('VAC_COND3', 'لا توجد قوات معززة لقرى أخرى');
define('VAC_COND4', 'ليس لدى أي لاعب تعزيزات في قراك');
define('VAC_COND5', 'لا تملك معجزة العالم');
define('VAC_COND6', 'لا تملك أي تحف');
define('VAC_COND7', 'لم تعد في حماية المبتدئين');
define('VAC_COND8', 'ليست لديك قوات في الفخاخ');
define('VAC_COND9', 'حسابك ليس في طور الحذف');
define('NOT_ENOUGH_RESOURCES', 'موارد غير كافية');
define('OFFER', 'عرض');
define('SEARCH', 'بحث');
define('OWN_OFFERS', 'عروضك الخاصة');
define('ALL', 'الكل');
define('NPC_TRADE', 'مبادلة تاجر');
define('SUM', 'المجموع');
define('REST', 'الباقي');
define('TRADE_RESOURCES', 'توزيع الموارد (خطوة 2 من 2)');
define('DISTRIBUTE_RESOURCES', 'توزيع الموارد (خطوة 1 من 2)');
define('OF', 'من');
define('NPC_COMPLETED', 'اكتملت مبادلة التاجر');
define('BACK_BUILDING', 'الرجوع للمبنى');
define('YOU_CAN_NAT_NPC_WW', 'لا يمكنك إجراء مبادلة تاجر في قرية المعجزة.');
define('NPC_TRADING', 'التبادل');
define('SEND_RESOURCES', 'إرسال الموارد');
define('BUY', 'شراء');
define('TRADE_ROUTES', 'طرق التجارة');
define('DESCRIPTION', 'الوصف');
define('G_DESCR', 'وصف عام');
define('TIME_LEFT', 'الوقت المتبقي');
define('START', 'البدء');
define('NO_TRADE_ROUTES', 'لا توجد طرق تجارة نشطة');
define('TRADE_ROUTE_TO', 'طريق التجارة إلى');
define('CHECKED', 'محدد');
define('DAYS', 'أيام');
define('EXTEND', 'توسيع');
define('EDIT', 'تعديل');
define('EXTEND_TRADE_ROUTES', 'توسيع طريق التجارة لمدة <b>7</b>  أيام مقابل');
define('CREATE_TRADE_ROUTES', 'إنشاء طريق تجارة جديد');
define('DELIVERIES', 'التسليمات');
define('START_TIME_TRADE', 'وقت البدء');
define('CREATE_TRADE_ROUTE', 'إنشاء طريق تجارة');
define('TARGET_VILLAGE', 'القرية الهدف');
define('EDIT_TRADE_ROUTES', 'تعديل طريق التجارة');
define('TRADE_ROUTES_DESC', 'تتيح لك طرق التجارة تحديد مسارات معينة يسلكها التاجر بانتظام.');
define('NPC_TRADE_DESC', 'مع مبادلة التاجر يمكنك توزيع الموارد الموجودة في مخازنك كما ترغب.');
define('MARKETPLACE_DESC', 'في السوق، يمكنك مبادلة الموارد مع اللاعبين الآخرين. كلما ارتفع المستوى زادت الموارد التي يحملها التجار.');

define('EMBASSY', 'السفارة');
define('TAG', 'اختصار');
define('TO_THE_ALLIANCE', 'عن التحالف');
define('JOIN_ALLIANCE', 'انضمام للتحالف');
define('REFUSE', 'رفض');
define('ACCEPT', 'قبول');
define('NO_INVITATIONS', 'لا توجد دعوات متاحة.');
define('NO_CREATE_ALLIANCE', 'اللاعب المحظور لا يمكنه إنشاء تحالف.');
define('FOUND_ALLIANCE', 'تأسيس تحالف');
define('EMBASSY_DESC', 'السفارة هي مكان الدبلوماسيين. في المستوى 1 يمكنك الانضمام لتحالف وبلوغ المستوى 3 يتيح لك إنشاء تحالف.');

define('BARRACKS', 'الثكنة');
define('QUANTITY', 'الكمية');
define('MAX', 'الأقصى');
define('TRAINING', 'تدريب');
define('FINISHED', 'مكتمل');
define('UNIT_FINISHED', 'الوحدة التالية ستكتمل في');
define('AVAILABLE', 'متاح');
define('TRAINING_COMMENCE_BARRACKS', 'يمكن بدء التدريب عند اكتمال الثكنة.');
define('BARRACKS_DESC', 'الثكنة حيث يتم تدريب جنود المشاة. كلما زاد المستوى زادت سرعة التدريب.');

define('STABLE', 'الإسطبل');
define('AVAILABLE_ACADEMY', 'لا وحدات متاحة. ابحث في الأكاديمية الحربية');
define('TRAINING_COMMENCE_STABLE', 'يمكن البدء بالتدريب عند اكتمال الإسطبل.');
define('STABLE_DESC', 'الإسطبل للخيالة. كلما زاد مستواه أصبحت تدريبات الخيالة أسرع.');

define('WORKSHOP', 'المصانع الحربية');
define('TRAINING_COMMENCE_WORKSHOP', 'يمكن البدء بالتدريب عند اكتمال المصانع الحربية.');
define('WORKSHOP_DESC', 'في المصانع الحربية يتم تصنيع آلات الحصار كالمقاليق والمحطمات.');

define('ACADEMY', 'الأكاديمية الحربية');
define('RESEARCH_AVAILABLE', 'لا توجد أبحاث متاحة');
define('RESEARCH_COMMENCE_ACADEMY', 'يمكن بدء البحث عند اكتمال الأكاديمية الحربية.');
define('RESEARCH', 'البحث');
define('EXPAND_WAREHOUSE1', 'تطوير المخزن');
define('EXPAND_GRANARY1', 'تطوير مخزن الحبوب');
define('RESEARCH_IN_PROGRESS', 'البحث<br>جاري');
define('RESEARCHING', 'جاري البحث');
define('PREREQUISITES', 'الشروط');
define('SHOW_MORE', 'عرض المزيد');
define('HIDE_MORE', 'إخفاء المزيد');
define('ACADEMY_DESC', 'الأكاديمية الحربية حيث يتم استكشاف القوات الجديدة.');

define('CRANNY', 'المخبأ');
define('CURRENT_HIDDEN_UNITS', 'الوحدات المخبأة لكل مورد:');
define('HIDDEN_UNITS_LEVEL', 'الوحدات المخبأة لكل مورد بالمستوى');
define('UNITS', 'وحدات');
define('CRANNY_DESC', 'يخبئ المخبأ جزءا من مواردك وقت الهجوم ليمنع نهبها.');

define('TOWNHALL', 'البلدية');
define('CELEBRATIONS_COMMENCE_TOWNHALL', 'يمكن عقد الاحتفالات عند اكتمال البلدية.');
define('GREAT_CELEBRATIONS', 'إحتفال كبير');
define('CULTURE_POINTS', 'النقاط الحضارية');
define('HOLD', 'إقامة');
define('CELEBRATIONS_IN_PROGRESS', 'الاحتفال<br>جاري');
define('CELEBRATIONS', 'احتفالات');
define('TOWNHALL_DESC', 'هنا في البلدية يمكنك إقامة الاحتفالات للحصول على نقاط حضارية إضافية لإنشاء قرى جديدة.');

define('RESIDENCE', 'السكن');
define('CAPITAL', 'هذه هي عاصمتك');
define('RESIDENCE_TRAIN_DESC', 'لتأسيس قرية جديدة تحتاج لمستوى 10 أو 20 و3 مستوطنين. لاحتلال قرية تحتاج مستوى 10 أو 20 ورئيس/زعيم/حكيم.');
define('PRODUCTION_POINTS', 'إنتاج هذه القرية:');
define('PRODUCTION_ALL_POINTS', 'إنتاج جميع القرى:');
define('POINTS_DAY', 'النقاط الحضارية باليوم');
define('VILLAGES_PRODUCED', 'أنتجت قراك');
define('POINTS_NEED', 'نقطة في المجموع. لتأسيس أو احتلال قرية جديدة تحتاج إلى');
define('POINTS', 'نقطة');
define('INHABITANTS', 'السكان');
define('COORDINATES', 'الإحداثيات');
define('EXPANSION', 'توسع');
define('TRAIN', 'تدريب');
define('DATE', 'التاريخ');
define('CONQUERED_BY_VILLAGE', 'قرى تم تأسيسها أو احتلالها من هذه القرية');
define('NONE_CONQUERED_BY_VILLAGE', 'لم يتم تأسيس أو احتلال أي قرية من هذه القرية بعد.');
define('RESIDENCE_CULTURE_DESC', 'لتوسيع إمبراطوريتك تحتاج إلى النقاط الحضارية التي تنتج من المباني.');
define('RESIDENCE_LOYALTY_DESC', 'من خلال الهجوم بالزعماء سينخفض ولاء القرية وبوصوله للصفر تنضم هذه القرية لك. الولاء الحالي هو ');
define('RESIDENCE_DESC', 'السكن يحمي القرية من الاحتلال، ويدرب المستوطنين أو الزعماء لتأسيس أو احتلال قرى جديدة.');

define('PALACE', 'القصر');
define('PALACE_CONSTRUCTION', 'القصر قيد الإنشاء');
define('PALACE_TRAIN_DESC', 'لتأسيس قرية جديدة تحتاج لمستوى 10 أو 15 أو 20 للقصر و 3 مستوطنين.');
define('CHANGE_CAPITAL', 'تغيير العاصمة');
define('SECURITY_CHANGE_CAPITAL', 'هل أنت متأكد من تغييرك للعاصمة؟<br><b>هذه العملية لا يمكن التراجع عنها!</b><br>تأكيد كلمة المرور:<br>');
define('PALACE_DESC', 'يمكن بناء قصر واحد بالإمبراطورية في عاصمتك. ويدرب المستوطنين أو الزعماء لتأسيس أو احتلال قرى جديدة.');

define('TREASURY', 'الخزنة');
define('TREASURY_COMMENCE', 'يمكن عرض التحف عند اكتمال الخزنة.');
define('ARTEFACTS_AREA', 'التحف في منطقتك');
define('NO_ARTEFACTS_AREA', 'لا توجد تحف في منطقتك.');
define('OWN_ARTEFACTS', 'التحف المملوكة');
define('CONQUERED', 'محتلة');
define('DISTANCE', 'المسافة');
define('EFFECT', 'تأثير');
define('ACCOUNT', 'حساب');
define('SMALL_ARTEFACTS', 'تحف صغيرة');
define('LARGE_ARTEFACTS', 'تحف كبيرة');
define('NO_ARTEFACTS', 'لا توجد تحف.');
define('ANY_ARTEFACTS', 'أنت لا تملك أي تحف.');
define('OWNER', 'المالك');
define('AREA_EFFECT', 'نطاق التأثير');
define('VILLAGE_EFFECT', 'تأثير على القرية');
define('ACCOUNT_EFFECT', 'تأثير على الحساب');
define('UNIQUE_EFFECT', 'تحف نادرة');
define('REQUIRED_LEVEL', 'المستوى المطلوب');
define('TIME_CONQUER', 'وقت الاحتلال');
define('TIME_ACTIVATION', 'وقت التفعيل');
define('NEXT_EFFECT', ' التأثير القادم');
define('FORMER_OWNER', 'المالك السابق');
define('BUILDING_STRONGER', 'المباني أقوى بـ');
define('BUILDING_WEAKER', 'المباني أضعف بـ');
define('TROOPS_FASTER', 'القوات أسرع بـ');
define('TROOPS_SLOWEST', 'القوات أبطأ بـ');
define('SPIES_INCREASE', 'يزيد المستكشفون بـ');
define('SPIES_DECRESE', 'يقل المستكشفون بـ');
define('CONSUME_LESS', 'استهلاك القوات أقل بـ');
define('CONSUME_HIGH', 'استهلاك القوات أعلى بـ');
define('TROOPS_MAKE_FASTER', 'القوات أسرع بـ');
define('TROOPS_MAKE_SLOWEST', 'القوات أبطأ بـ');
define('YOU_CONSTRUCT', 'يمكنك بناء ');
define('CRANNY_INCREASED', 'مساحة المخبأ تزيد بـ');
define('CRANNY_DECRESE', 'مساحة المخبأ تقل بـ');
define('WW_BUILDING_PLAN', 'يمكنك بناء معجزة العالم');
define('NO_WW', 'لا توجد معجزات عالم');
define('NO_PREVIOUS_OWNERS', 'لا يوجد ملاك سابقون.');
define('TREASURY_DESC', 'ثروتك من التحف تحفظ هنا بالخزنة.');

define('TRADEOFFICE', 'المكتب التجاري');
define('CURRENT_MERCHANT', 'حمولة التاجر الحالية:');
define('MERCHANT_LEVEL', 'حمولة التاجر عند المستوى');
define('TRADEOFFICE_DESC', 'هنا يتم تحسين قدرات التجار لحمل المزيد من الموارد.');

define('GREATBARRACKS', 'الثكنة الكبيرة');
define('TRAINING_COMMENCE_GREATBARRACKS', 'يمكن التدريب هنا عند اكتمال المبنى.');
define('GREATBARRACKS_DESC', 'تسمح لك الثكنة الكبيرة بالتدريب المزدوج للمشاة ولكن بتكلفة مضاعفة 3 مرات.');

define('GREATSTABLE', 'الإسطبل الكبير');
define('TRAINING_COMMENCE_GREATSTABLE', 'يمكن التدريب هنا عند اكتمال المبنى.');
define('GREATSTABLE_DESC', 'يسمح الإسطبل الكبير بالتدريب المزدوج للفرسان، ولكن بتكلفة مضاعفة 3 مرات.');

define('CITYWALL', 'سور المدينة');
define('DEFENCE_NOW', 'مكافأة الدفاع الحالية:');
define('DEFENCE_LEVEL', 'مكافأة الدفاع عند المستوى');
define('CITYWALL_DESC', 'يوفر السور حماية إضافية للرومان.');

define('EARTHWALL', 'الخندق الأرضي');
define('EARTHWALL_DESC', 'الخندق الأرضي الخاص بالجرمان يوفر حماية إضافية.');

define('PALISADE', 'الحاجز الخشبي');
define('PALISADE_DESC', 'يوفر حماية جيدة ومتوازنة لقرى الإغريق.');

define('STONEMASON', 'الحجار');
define('CURRENT_STABILITY', 'الصلابة الحالية:');
define('STABILITY_LEVEL', 'الصلابة عند المستوي');
define('STONEMASON_DESC', 'يزيد الحجار من قوة مبانيك وصلابتها ضد هجمات المقاليع.');

define('BREWERY', 'الخمارة');
define('CURRENT_BONUS', 'المكافأة الحالية:');
define('BONUS_LEVEL', 'المكافأة عند المستوى');
define('BREWERY_DESC', 'تزيد الخمارة من شراسة هجوم جنودك الجرمان وتقام فقط بالعاصمة.');

define('TRAPPER', 'الصياد');
define('CURRENT_TRAPS', 'الحد الأقصى للفخاخ الحالي:');
define('TRAPS_LEVEL', 'الحد الأقصى للفخاخ عند المستوى');
define('TRAPS', 'فخاخ');
define('TRAP', 'فخ');
define('CURRENT_HAVE', 'لديك حالياً');
define('WHICH_OCCUPIED', 'منها مشغولة.');
define('TRAINING_COMMENCE_TRAPPER', 'يبدأ التدريب عند اكتمال الصياد.');
define('TRAPPER_DESC', 'يحمي الصياد قراك بوضع الفخاخ المخفية للامساك بالأعداء المهاجمين للإغريق.');

define('HEROSMANSION', 'قصر الأبطال');
define('HERO_READY', 'بطلك سيكون جاهزاً خلال ');
define('NAME_CHANGED', 'تم تغيير اسم البطَِل');
define('NOT_UNITS', 'وحدات غير متاحة');
define('NOT', 'لا ');
define('TRAIN_HERO', 'تدريب بطل جديد');
define('REVIVE', 'إنعاش');
define('OASES', 'الواحات');
define('DELETE', 'हذف');
define('RESOURCES', 'موارد');
define('OFFENCE', 'هجوم');
define('DEFENCE', 'دفاع');
define('OFF_BONUS', 'مكافأة هجومية');
define('DEF_BONUS', 'مكافأة دفاعية');
define('REGENERATION', 'استعادة العافية');
define('DAY', 'يوم');
define('EXPERIENCE', 'خبرة');
define('YOU_CAN', 'يمكنك ');
define('RESET', 'إعادة تعيين');
define('YOUR_POINT_UNTIL', ' نقاطك حتى تصل للمستوى ');
define('OR_LOWER', ' أو أقل!');
define('YOUR_HERO_HAS', 'لدى بطلك ');
define('OF_HIT_POINTS', 'من صحته');
define('ERROR_NAME_SHORT', 'خطأ: الاسم قصير');
define('HEROSMANSION_DESC', 'من هنا تقوم بإنتاج بطلك ووضعه لاحتلال الواحات لزيادة إنتاجك.');

define('GREATWAREHOUSE', 'المخزن الكبير');
define('GREATWAREHOUSE_DESC', 'لهذا المخزن ثلاثة أضعاف السعة للمخزن العادي. يبنى في قرية المعجزة أو بواسطة تحفة التتار.');

define('GREATGRANARY', 'مخزن الحبوب الكبير');
define('GREATGRANARY_DESC', 'السعة ثلاثة أضعاف مخزن الحبوب العادي. يبنى بقرية المعجزة أو كتحفة.');

define('WONDER', 'معجزة العالم');
define('WORLD_WONDER', 'معجزة العالم');
define('WONDER_DESC', 'شيد المعجزة وأنه للوصول إلى المجد، يتطلب ذلك تخطيطاً كبيراً وتحف ومقداراً هائلاً من الموارد.');
define('WORLD_WONDER_CHANGE_NAME', 'تتطلب مستوى 1 لتغيير الاسم');
define('WORLD_WONDER_NAME', 'اسم المعجزة');
define('WORLD_WONDER_NOTCHANGE_NAME', 'لا يمكنك تغيير الاسم بعد مستوى 10');
define('WORLD_WONDER_NAME_CHANGED', 'تم تغيير الاسم');

define('HORSEDRINKING', 'حوض شرب الخيول');
define('HORSEDRINKING_DESC', 'يخفض زمن تدريب الخيالة الرومانية واستهلاكهم للقمح.');

define('GREATWORKSHOP', 'المصانع الحربية الكبيرة');
define('TRAINING_COMMENCE_GREATWORKSHOP', 'يبدأ التدريب عند اكتمال المصانع الحربية الكبيرة.');
define('GREATWORKSHOP_DESC', 'يسمح لك بصنع المقلاع والمحطمة بسرعة مضاعفة.');

define('BUILDING_MAX_LEVEL_UNDER', 'أقصى مستوى للمبنى قيد الإنشاء');
define('BUILDING_BEING_DEMOLISHED', 'المبنى حاليا قيد الهدم');
define('COSTS_UPGRADING_LEVEL', 'تكاليف</b> التطوير للمستوى');
define('WORKERS_ALREADY_WORK', 'عمال البناء يعملون حالياً.');
define('CONSTRUCTING_MASTER_BUILDER', 'قيد البناء بواسطة مهندس البناء ');
define('COSTS', 'التكاليف');
define('WORKERS_ALREADY_WORK_WAITING', 'عمال البناء يعملون حالياً. (في الانتظار)');
define('ENOUGH_FOOD_EXPAND_CROPLAND', 'الغذاء لا يكفي. طور حقول القمح.');
define('UPGRADE_WAREHOUSE', 'طور المخزن');
define('UPGRADE_GRANARY', 'طور مخزن الحبوب');
define('YOUR_CROP_NEGATIVE', 'إنتاجك من القمح سلبي لن تصل للموارد المطلوبة.');
define('UPGRADE_LEVEL', 'تطوير للمستوى ');
define('WAITING', '(حلقة الانتظار)');
define('NEED_WWCONSTRUCTION_PLAN', 'يتطلب مخططات معجزة');
define('NEED_MORE_WWCONSTRUCTION_PLAN', 'يحتاج مخططات إضافية');
define('CONSTRUCT_NEW_BUILDING', 'بناء مبنى جديد');
define('SHOWSOON_AVAILABLE_BUILDINGS', 'عرض المباني المتاحة قريباً');
define('HIDESOON_AVAILABLE_BUILDINGS', 'إخفاء المباني المتاحة قريباً');

define('UPGRADE_TO_MAX_LEVEL', 'ترقية لأقصى مستوى (20)');
define('GOLD_COST_REMAINING', 'ذهب');
