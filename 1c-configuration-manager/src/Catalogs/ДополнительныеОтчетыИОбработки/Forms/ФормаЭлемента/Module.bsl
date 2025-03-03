&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = Объект.Ссылка.Пустая();
	
	Если ЭтоНовый=Истина Тогда
		ЗаполнитьВиртуальныеРазделы();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Вставить содержимое обработчика
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЭтоНовый = Ложь;
	ЗаполнитьВиртуальныеРазделы();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаФорма(Команда)
	ОбновлениеИзФайлаЗапуск()
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеИзФайлаЗапуск()
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Успех", Ложь);
	ПараметрыРегистрации.Вставить("АдресДанныхОбработки", АдресДанныхОбработки);
	Обработчик = Новый ОписаниеОповещения("ОбновлениеИзФайлаПослеВыбораФайла", ЭтотОбъект, ПараметрыРегистрации);
	
	Фильтр = НСтр("ru = 'Внешние отчеты и обработки (*.%1, *.%2)|*.%1;*.%2|Внешние отчеты (*.%1)|*.%1|Внешние обработки (*.%2)|*.%2'");
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Фильтр, "erf", "epf");
	
	ПараметрыДиалога = Новый Структура("Режим, Фильтр, ИндексФильтра, Заголовок");
	ПараметрыДиалога.Режим  = РежимДиалогаВыбораФайла.Открытие;
	ПараметрыДиалога.Фильтр = Фильтр;
	
	Если Объект.Ссылка.Пустая() Тогда
		ПараметрыДиалога.ИндексФильтра = 0;
		ПараметрыДиалога.Заголовок = НСтр("ru = 'Выберите файл внешнего отчета или обработки'");
	ИначеЕсли Объект.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет") Или Объект.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.Отчет") Тогда
		ПараметрыДиалога.ИндексФильтра = 1;
		ПараметрыДиалога.Заголовок = НСтр("ru = 'Выберите файл внешнего отчета'");
	Иначе
		ПараметрыДиалога.ИндексФильтра = 2;
		ПараметрыДиалога.Заголовок = НСтр("ru = 'Выберите файл внешней обработки'");
	КонецЕсли;
	
	//Диалог = Новый ДиалогВыбораФайла(ПараметрыДиалога.Режим); 
	//ЗаполнитьЗначенияСвойств(Диалог,ПараметрыДиалога);
	//Диалог.Показать(Обработчик);
	
	СтандартныеПодсистемыКлиент.ПоказатьПомещениеФайла(Обработчик, УникальныйИдентификатор, Объект.ИмяФайла, ПараметрыДиалога);
	
КонецПроцедуры


&НаКлиенте
Процедура ОбновлениеИзФайлаПослеВыбораФайла(ПомещенныеФайлы, ПараметрыРегистрации) Экспорт
	Если ПомещенныеФайлы = Неопределено Или ПомещенныеФайлы.Количество() = 0 Тогда
		//ОбновлениеИзФайлаЗавершение(Неопределено, ПараметрыРегистрации);
		Возврат;
	КонецЕсли;
	
	ОписаниеФайла = ПомещенныеФайлы[0];
	
	ПараметрыРегистрации.Вставить("ИмяФайла","");
	ПараметрыРегистрации.Вставить("ЭтоОтчет",Ложь);
	ПараметрыРегистрации.Вставить("ОтключатьПубликацию",Ложь);
	ПараметрыРегистрации.Вставить("ОтключатьКонфликтующие",Ложь);
	ПараметрыРегистрации.Вставить("Конфликтующие",Новый СписокЗначений);
	
	МассивПодстрок = СтрРазделить(ОписаниеФайла.Имя, "\", Ложь);
	ПараметрыРегистрации.ИмяФайла = МассивПодстрок.Получить(МассивПодстрок.ВГраница());
	РасширениеФайла = ВРег(Прав(ПараметрыРегистрации.ИмяФайла, 3));
	
	Если РасширениеФайла = "ERF" Тогда
		ПараметрыРегистрации.ЭтоОтчет = Истина;
	ИначеЕсли РасширениеФайла = "EPF" Тогда
		ПараметрыРегистрации.ЭтоОтчет = Ложь;
	Иначе
		ПараметрыРегистрации.Успех = Ложь;
		ВернутьРезультатПослеПоказаПредупреждения(
			НСтр("ru = 'Расширение файла не соответствует расширению внешнего отчета (ERF) или обработки (EPF).'"),
			Новый ОписаниеОповещения("ОбновлениеИзФайлаЗавершение", ЭтотОбъект, ПараметрыРегистрации),
			Неопределено);
		Возврат;
	КонецЕсли;
	
	ПараметрыРегистрации.АдресДанныхОбработки = ОписаниеФайла.Хранение;
	
	ОбновлениеИзФайлаМеханикаНаКлиенте(ПараметрыРегистрации);
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеИзФайлаМеханикаНаКлиенте(ПараметрыРегистрации)
	// Вызов сервера.
	ОбновлениеИзФайлаМеханикаНаСервере(ПараметрыРегистрации);
	
	Если ПараметрыРегистрации.ОтключатьКонфликтующие Тогда
		// Отключается несколько объектов, потому динамические списки надо обновить.
		ОповеститьОбИзменении(Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки"));
	КонецЕсли;
	
	// Обработка результата работы сервера.
	Если ПараметрыРегистрации.Успех Тогда
		ОповещениеЗаголовок = ?(ПараметрыРегистрации.ЭтоОтчет, НСтр("ru = 'Файл внешнего отчета загружен'"), НСтр("ru = 'Файл внешней обработки загружен'"));
		ОповещениеСсылка    = ?(ЭтоНовый, "", ПолучитьНавигационнуюСсылку(Объект.Ссылка));
		ОповещениеТекст     = ПараметрыРегистрации.ИмяФайла;
		ПоказатьОповещениеПользователя(ОповещениеЗаголовок, ОповещениеСсылка, ОповещениеТекст);
		ОбновлениеИзФайлаЗавершение(Неопределено, ПараметрыРегистрации);
	Иначе
		//// Разбор причины отказа загрузки обработки и отображение информации пользователю.
		//Если ПараметрыРегистрации.ИмяОбъектаЗанято Тогда
		//	ОбновлениеИзФайлаПоказатьКонфликты(ПараметрыРегистрации);
		//Иначе
		//	ОбработчикРезультата = Новый ОписаниеОповещения("ОбновлениеИзФайлаЗавершение", ЭтотОбъект, ПараметрыРегистрации);
		//	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтотОбъект, ПараметрыРегистрации, ОбработчикРезультата);
		//КонецЕсли;
		Сообщить("Произошла ошибка при добавлении!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновлениеИзФайлаМеханикаНаСервере(ПараметрыРегистрации)
	ОбъектСправочника = РеквизитФормыВЗначение("Объект");
	КомандыСохраненные = ОбъектСправочника.Команды.Выгрузить();
	
	ОбъектСправочника.ХранилищеОбработки = новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(ПараметрыРегистрации.АдресДанныхОбработки));
	
	Результат = Новый Структура("ИмяОбъекта, СтароеИмяОбъекта, Успех, ИмяОбъектаЗанято, Конфликтующие, ТекстОшибки, КраткоеПредставлениеОшибки");
	Результат.ИмяОбъектаЗанято = Ложь;
	Результат.Успех = Ложь;

	РегистрационныеДанные = Новый Структура;
	
	СтандартнаяОбработка = Истина;
	
	Если СтандартнаяОбработка Тогда
		ПриПолученииРегистрационныхДанных(ОбъектСправочника, РегистрационныеДанные, ПараметрыРегистрации, Результат);
		ЗаполнитьЗначенияСвойств(ОбъектСправочника,РегистрационныеДанные);
		ОбъектСправочника.Команды.Очистить();
		Для каждого стр из РегистрационныеДанные.Команды Цикл
			стр_н = ОбъектСправочника.Команды.Добавить();
			ЗаполнитьЗначенияСвойств(стр_н,стр);
			стр_н.ПросмотрВсе = Истина;
			//Если НЕ ЗначениеЗаполнено(стр_н.Описание) Тогда
			//	стр_н.Описание = стр_н.Представление;
			//КонецЕсли;
		КонецЦикла;
		ОбъектСправочника.ИмяФайла = ПараметрыРегистрации.ИмяФайла;
		ОбъектСправочника.ИмяОбъекта = Результат.ИмяОбъекта;		
	КонецЕсли;
	
	ОбъектСправочника.Записать();
   	Модифицированность = Ложь;	
	
	ЗначениеВРеквизитФормы(ОбъектСправочника, "Объект");
	
КонецПроцедуры

// Для внутреннего использования.
&НаСервере
Процедура ПриПолученииРегистрационныхДанных(Объект, РегистрационныеДанные, ПараметрыРегистрации, РезультатРегистрации)
	
	// Подключение и получение имени, под которым объект будет подключаться.
	Менеджер = ?(ПараметрыРегистрации.ЭтоОтчет, ВнешниеОтчеты, ВнешниеОбработки);
	
	ИнформацияОбОшибке = Неопределено;
	Попытка
		#Если ТолстыйКлиентОбычноеПриложение Тогда
			РезультатРегистрации.ИмяОбъекта = ПолучитьИмяВременногоФайла();
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПараметрыРегистрации.АдресДанныхОбработки);
			ДвоичныеДанные.Записать(РезультатРегистрации.ИмяОбъекта);
		#Иначе
			РезультатРегистрации.ИмяОбъекта = СокрЛП(Менеджер.Подключить(ПараметрыРегистрации.АдресДанныхОбработки, , Истина));
		#КонецЕсли
		
		// Получение сведений о внешней обработке.
		ВнешнийОбъект = Менеджер.Создать(РезультатРегистрации.ИмяОбъекта);
		ВнешнийОбъектМетаданные = ВнешнийОбъект.Метаданные();
		
		СведенияОВнешнейОбработке = ВнешнийОбъект.СведенияОВнешнейОбработке();
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(РегистрационныеДанные, СведенияОВнешнейОбработке, Истина);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
	КонецПопытки;
	Если ИнформацияОбОшибке <> Неопределено Тогда
		Если ПараметрыРегистрации.ЭтоОтчет Тогда
			ТекстОшибки = НСтр("ru='Невозможно подключить дополнительный отчет из файла.
			|Возможно, он не подходит для этой версии программы.'");
		Иначе
			ТекстОшибки = НСтр("ru='Невозможно подключить дополнительную обработку из файла.
			|Возможно, она не подходит для этой версии программы.'");
		КонецЕсли;
		РезультатРегистрации.ТекстОшибки = ТекстОшибки;
		РезультатРегистрации.КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС + НСтр("ru = 'Техническая информация:'") + Символы.ПС;
		ЗаписатьОшибку(Объект.Ссылка, ТекстОшибки + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат;
	КонецЕсли;
	
	Если РегистрационныеДанные.Наименование = Неопределено ИЛИ РегистрационныеДанные.Информация = Неопределено Тогда
		Если РегистрационныеДанные.Наименование = Неопределено Тогда
			РегистрационныеДанные.Наименование = ВнешнийОбъектМетаданные.Представление();
		КонецЕсли;
		Если РегистрационныеДанные.Информация = Неопределено Тогда
			РегистрационныеДанные.Информация = ВнешнийОбъектМетаданные.Комментарий;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(РегистрационныеДанные.Вид) <> Тип("ПеречислениеСсылка.ВидыДополнительныхОтчетовИОбработок") Тогда
		РегистрационныеДанные.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок[РегистрационныеДанные.Вид];
	КонецЕсли;
	
	РегистрационныеДанные.Вставить("ХранилищеВариантов");
	Если РегистрационныеДанные.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет
		Или РегистрационныеДанные.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Тогда
		Если ВнешнийОбъектМетаданные.ХранилищеВариантов <> Неопределено Тогда
			РегистрационныеДанные.ХранилищеВариантов = ВнешнийОбъектМетаданные.ХранилищеВариантов.Имя;
		КонецЕсли;
	КонецЕсли;
	
	РегистрационныеДанные.Команды.Колонки.Добавить("ВариантЗапуска");
	
	Для Каждого КомандаОписание Из РегистрационныеДанные.Команды Цикл
		КомандаОписание.ВариантЗапуска = Перечисления.СпособыВызоваДополнительныхОбработок[КомандаОписание.Использование];
	КонецЦикла;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		РезультатРегистрации.ИмяОбъекта = ВнешнийОбъектМетаданные.Имя;
	#КонецЕсли
	
	ПараметрыРегистрации.Успех = Истина;
	
КонецПроцедуры

// Запись ошибки в журнал регистрации по дополнительному отчету или обработке.
&НаСервере
Процедура ЗаписатьОшибку(Ссылка, ТекстСообщения, Реквизит1 = Неопределено, Реквизит2 = Неопределено, Реквизит3 = Неопределено) Экспорт
	Уровень = УровеньЖурналаРегистрации.Ошибка;
	ЗаписатьВЖурнал(Уровень, Ссылка, ТекстСообщения, Реквизит1, Реквизит2, Реквизит3);
КонецПроцедуры

// Запись события в журнал регистрации по дополнительному отчету или обработке.
&НаСервере
Процедура ЗаписатьВЖурнал(Уровень, Ссылка, Текст, Параметр1, Параметр2, Параметр3)
	Текст = СтрЗаменить(Текст, "%1", Параметр1); // Переход на СтрШаблон невозможен.
	Текст = СтрЗаменить(Текст, "%2", Параметр2);
	Текст = СтрЗаменить(Текст, "%3", Параметр3);
	ЗаписьЖурналаРегистрации(
		"Ошибка работы с доп обработками",
		Уровень,
		Метаданные.Справочники.ДополнительныеОтчетыИОбработки,
		Ссылка,
		Текст);
КонецПроцедуры


&НаКлиенте
Процедура ОбновлениеИзФайлаЗавершение(ПустойРезультат, ПараметрыРегистрации) Экспорт
	Если ПараметрыРегистрации = Неопределено Или ПараметрыРегистрации.Успех = Ложь Тогда
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
	ИначеЕсли ПараметрыРегистрации.Успех = Истина Тогда
		Если Не Открыта() Тогда
			Открыть();
		КонецЕсли;
		Модифицированность = Истина;
		РегистрацияОбработки = Истина;
		АдресДанныхОбработки = ПараметрыРегистрации.АдресДанныхОбработки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВернутьРезультатПослеПоказаПредупреждения(ТекстПредупреждения, Обработчик, Результат, Заголовок = Неопределено, Таймаут = 0)
	// Показывает окно предупреждение, а после его закрытия вызывает обработчик с заданным результатом.
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Обработчик", Обработчик);
	ПараметрыОбработчика.Вставить("Результат", Результат);
	Обработчик = Новый ОписаниеОповещения("ВернутьРезультатПослеЗакрытияПростогоДиалога", ЭтотОбъект, ПараметрыОбработчика);
	ПоказатьПредупреждение(Обработчик, ТекстПредупреждения, Таймаут, Заголовок);
КонецПроцедуры


&НаКлиенте
Процедура ВыгрузитьВФайлФорма(Команда)
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("ЭтоОтчет", Объект.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.Отчет") Или Объект.Вид = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет"));
	ПараметрыВыгрузки.Вставить("ИмяФайла", Объект.ИмяФайла);
	ПараметрыВыгрузки.Вставить("АдресДанныхОбработки", АдресДанныхОбработки);
	ПараметрыВыгрузки.Вставить("Ссылка",Объект.Ссылка);
	ВыгрузитьВФайл(ПараметрыВыгрузки);
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВФайл(ПараметрыВыгрузки) Экспорт
	ТекстСообщения = НСтр("ru = 'Для выгрузки внешней обработки (отчета) в файл рекомендуется установить расширение для веб-клиента 1С:Предприятие.'");
	Обработчик = Новый ОписаниеОповещения("ВыгрузитьВФайлЗавершение", ЭтотОбъект, ПараметрыВыгрузки);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик, ТекстСообщения);
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВФайлЗавершение(Подключено, ПараметрыВыгрузки) Экспорт
	Перем Адрес;
	
	ПараметрыВыгрузки.Свойство("АдресДанныхОбработки", Адрес);
	Если Не ЗначениеЗаполнено(Адрес) Тогда
		Адрес = ПоместитьВХранилище(ПараметрыВыгрузки.Ссылка, Неопределено);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыВыгрузки", ПараметрыВыгрузки);
	ДополнительныеПараметры.Вставить("Адрес", Адрес);
	
	Если Не Подключено Тогда
		ПолучитьФайл(Адрес, ПараметрыВыгрузки.ИмяФайла, Истина);
		Возврат;
	КонецЕсли;
	
	Фильтр = НСтр("ru = 'Внешние отчеты и обработки (*.%1, *.%2)|*.%1;*.%2|Внешние отчеты (*.%1)|*.%1|Внешние обработки (*.%2)|*.%2'");
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Фильтр, "erf", "epf");

	
	ДиалогСохраненияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогСохраненияФайла.ПолноеИмяФайла = ПараметрыВыгрузки.ИмяФайла;
	ДиалогСохраненияФайла.Фильтр = Фильтр;
	ДиалогСохраненияФайла.ИндексФильтра = ?(ПараметрыВыгрузки.ЭтоОтчет, 1, 2);
	ДиалогСохраненияФайла.МножественныйВыбор = Ложь;
	ДиалогСохраненияФайла.Заголовок = НСтр("ru = 'Укажите файл'");
	
	Обработчик = Новый ОписаниеОповещения("ВыгрузитьФайлВыборФайла", ЭтотОбъект, ДополнительныеПараметры);
	ДиалогСохраненияФайла.Показать(Обработчик);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьВХранилище(Ссылка, ИдентификаторФормы) Экспорт
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") 
		Или Ссылка = ПредопределенноеЗначение("Справочник.ДополнительныеОтчетыИОбработки.ПустаяСсылка") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ХранилищеОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ХранилищеОбработки");
	
	Возврат ПоместитьВоВременноеХранилище(ХранилищеОбработки.Получить(), ИдентификаторФормы);
КонецФункции

&НаКлиенте
Процедура ВыгрузитьФайлВыборФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		ПолноеИмяФайла = ВыбранныеФайлы[0];
		ПолучаемыеФайлы = Новый Массив;
		ПолучаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ПолноеИмяФайла, ДополнительныеПараметры.Адрес));
		
		Обработчик = Новый ОписаниеОповещения("ВыгрузитьФайлПолучениеФайла", ЭтотОбъект);
		НачатьПолучениеФайлов(Обработчик, ПолучаемыеФайлы, ПолноеИмяФайла, Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик результата работы процедуры ВыгрузитьВФайл.
&НаКлиенте
Процедура ВыгрузитьФайлПолучениеФайла(ПолученныеФайлы, ДополнительныеПараметры) Экспорт
	// Обработка результата не требуется.
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьВиртуальныеРазделы()
	
	ВиртуальныеРазделы.Очистить();
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ИдентификаторыОбъектовМетаданных.Ссылка как Раздел,
	|	ВЫБОР
	|		КОГДА НЕ ДополнительныеОтчетыИОбработкиРазделы.Ссылка ЕСТЬ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Выбран
	|ИЗ
	|	Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Разделы КАК ДополнительныеОтчетыИОбработкиРазделы
	|		ПО ДополнительныеОтчетыИОбработкиРазделы.Раздел = ИдентификаторыОбъектовМетаданных.Ссылка
	|			И (ДополнительныеОтчетыИОбработкиРазделы.Ссылка = &Ссылка)
	|ГДЕ
	|	ИдентификаторыОбъектовМетаданных.Ссылка В ИЕРАРХИИ(&Подсистемы)";
	Запрос.УстановитьПараметр("Ссылка",Объект.Ссылка);
	Запрос.УстановитьПараметр("Подсистемы",Справочники.ИдентификаторыОбъектовМетаданных.ИдентификаторОбъектаМетаданныхПоПолномуИмени("Подсистемы"));
	
	ВиртуальныеРазделы.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.Разделы.Очистить();
	Для каждого стр из ВиртуальныеРазделы Цикл
		Если стр.Выбран=Ложь Тогда
			Продолжить;
		КонецЕсли;
		стр_н = Объект.Разделы.Добавить();
		ЗаполнитьЗначенияСвойств(стр_н,стр);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ЗаполнитьВиртуальныеРазделы();
КонецПроцедуры
