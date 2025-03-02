#Область ОткрытьНавигационнуюСсылку

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку.
Процедура ОткрытьНавигационнуюСсылкуПослеПроверкиРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	НавигационнаяСсылка = Контекст.НавигационнаяСсылка;
	
	Если РасширениеПодключено Тогда
		
		Оповещение          = Контекст.Оповещение;
		ДождатьсяЗавершения = (Оповещение <> Неопределено);
		
		Оповещение = Новый ОписаниеОповещения("ОткрытьНавигационнуюСсылкуПослеЗапускаПриложения", ЭтотОбъект, Контекст,
			"ОткрытьНавигационнуюСсылкуПриОбработкеОшибки", ЭтотОбъект);
		НачатьЗапускПриложения(Оповещение, НавигационнаяСсылка,, ДождатьсяЗавершения);
		
	Иначе
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Расширение для работы с файлами не установлено, переход по ссылке ""%1"" невозможен.'"),
			НавигационнаяСсылка);
		ОткрытьНавигационнуюСсылкуОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку.
Процедура ОткрытьНавигационнуюСсылкуПослеЗапускаПриложения(КодВозврата, Контекст) Экспорт 
	
	Оповещение = Контекст.Оповещение;
	
	Если Оповещение <> Неопределено Тогда 
		ПриложениеЗапущено = (КодВозврата = 0 Или КодВозврата = Неопределено);
		ВыполнитьОбработкуОповещения(Оповещение, ПриложениеЗапущено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку.
Процедура ОткрытьНавигационнуюСсылкуПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	СтандартнаяОбработка = Ложь;
	ОткрытьНавигационнуюСсылкуОповеститьОбОшибке("", Контекст);
	
КонецПроцедуры

// Продолжение процедуры ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку.
Процедура ОткрытьНавигационнуюСсылкуОповеститьОбОшибке(ОписаниеОшибки, Контекст) Экспорт
	
	Оповещение = Контекст.Оповещение;
	
	Если Оповещение = Неопределено Тогда
		Если Не ПустаяСтрока(ОписаниеОшибки) Тогда 
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	Иначе 
		ПриложениеЗапущено = Ложь;
		ВыполнитьОбработкуОповещения(Оповещение, ПриложениеЗапущено);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет, является ли переданная строка веб ссылкой.
// 
// Параметры:
//  Строка - Строка - переданная ссылка.
//
Функция ЭтоВебСсылка(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "http://")  // обычное соединение.
		Или СтрНачинаетсяС(Строка, "https://");// защищенное соединение.
	
КонецФункции

// Проверяет, является ли переданная строка ссылкой на встроенную справку.
// 
// Параметры:
//  Строка - Строка - переданная ссылка.
//
Функция ЭтоСсылкаНаСправку(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "v8help://");
	
КонецФункции

// Проверяет, является ли переданная строка допустимой ссылкой по белому списку протоколов.
// 
// Параметры:
//  Строка - Строка - переданная ссылка.
//
Функция ЭтоДопустимаяСсылка(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "e1cib/")
		Или СтрНачинаетсяС(Строка, "http:")
		Или СтрНачинаетсяС(Строка, "https:")
		Или СтрНачинаетсяС(Строка, "e1c:")
		Или СтрНачинаетсяС(Строка, "v8help:")
		Или СтрНачинаетсяС(Строка, "mailto:")
		Или СтрНачинаетсяС(Строка, "tel:")
		Или СтрНачинаетсяС(Строка, "skype:");
	
КонецФункции

#КонецОбласти

// Проверяет, является ли переданная строка внутренней навигационной ссылкой.
//  
// Параметры:
//  Строка - Строка - навигационная ссылка.
//
Функция ЭтоНавигационнаяСсылка(Строка) Экспорт
	
	Возврат СтрНачинаетсяС(Строка, "e1c:")
		Или СтрНачинаетсяС(Строка, "e1cib/");
	
КонецФункции
