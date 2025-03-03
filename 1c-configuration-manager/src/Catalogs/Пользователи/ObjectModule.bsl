#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ЭтоНовый;

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// уберем проверку заполнения для 
	Если АутентификацияОС=Ложь Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ПользовательОС"));
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = ЭтоНовый();

	СисИнфо = новый СистемнаяИнформация();
	ЕстьФлагЗащитаОтОпасныхДействий	= Истина;
	Если Найти(СисИнфо.ВерсияПриложения,"8.2.") ИЛИ
		Найти(СисИнфо.ВерсияПриложения,"8.3.0.") ИЛИ
		Найти(СисИнфо.ВерсияПриложения,"8.3.1.") ИЛИ
		Найти(СисИнфо.ВерсияПриложения,"8.3.2.") ИЛИ
		Найти(СисИнфо.ВерсияПриложения,"8.3.3.") ИЛИ
		Найти(СисИнфо.ВерсияПриложения,"8.3.4.") ИЛИ
		Найти(СисИнфо.ВерсияПриложения,"8.3.5.") ИЛИ
		Найти(СисИнфо.ВерсияПриложения,"8.3.6.") ИЛИ
		Найти(СисИнфо.ВерсияПриложения,"8.3.7.") ИЛИ
		Найти(СисИнфо.ВерсияПриложения,"8.3.8.") Тогда
		ЕстьФлагЗащитаОтОпасныхДействий = Ложь;
	КонецЕсли;
	
	// создание пользователя, если новый
	Если Недействителен=Ложь Тогда
		Если ЭтоНовый ИЛИ НЕ ЗначениеЗаполнено(ИдентификаторПользователяИБ) Тогда
			
			ПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя(); 
			ПользовательИБ.Имя = НаименованиеСокращенное; 
			ПользовательИБ.ПолноеИмя = Наименование; 
			ПользовательИБ.АутентификацияСтандартная = АутентификацияСтандартная;
			Если АутентификацияСтандартная Тогда
				ПользовательИБ.Пароль = Пароль1С.Получить();
			КонецЕсли;
			ПользовательИБ.АутентификацияОС = АутентификацияОС; 
			ПользовательИБ.ПользовательОС = ПользовательОС; 
			ПользовательИБ.ПоказыватьВСпискеВыбора = ПоказыватьВСпискеВыбора;
			ПользовательИБ.ЗапрещеноИзменятьПароль = ЗапрещеноИзменятьПароль;
			Если РежимЗапуска=Перечисления.РежимЗапускаКлиентскогоПриложения.Авто Тогда
				ПользовательИБ.РежимЗапуска=РежимЗапускаКлиентскогоПриложения.Авто;
			ИначеЕсли РежимЗапуска=Перечисления.РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение Тогда
				ПользовательИБ.РежимЗапуска=РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение;
			Иначе
				ПользовательИБ.РежимЗапуска=РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение;
			КонецЕсли;
			Если ЕстьФлагЗащитаОтОпасныхДействий=Истина Тогда
				ПользовательИБ.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = ЗащитаОтОпасныхДействий;
			КонецЕсли;
			
			ОбновитьТаблицуПравПользователяИБ(ПользовательИБ);
			
			ПользовательИБ.Записать(); 
			
			ИдентификаторПользователяИБ = ПользовательИБ.УникальныйИдентификатор; 
		Иначе
			
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);	
			Если НЕ ПользовательИБ=Неопределено Тогда
				
				
				ПользовательИБ.Имя = НаименованиеСокращенное; 
				ПользовательИБ.ПолноеИмя = Наименование; 
				ПользовательИБ.АутентификацияСтандартная = АутентификацияСтандартная;
				Если АутентификацияСтандартная Тогда
					ПользовательИБ.Пароль = Пароль1С.Получить();
				КонецЕсли;
				ПользовательИБ.АутентификацияОС = АутентификацияОС; 
				ПользовательИБ.ПользовательОС = ПользовательОС; 
				ПользовательИБ.ПоказыватьВСпискеВыбора = ПоказыватьВСпискеВыбора;
				ПользовательИБ.ЗапрещеноИзменятьПароль = ЗапрещеноИзменятьПароль;
				Если РежимЗапуска=Перечисления.РежимЗапускаКлиентскогоПриложения.Авто Тогда
					ПользовательИБ.РежимЗапуска=РежимЗапускаКлиентскогоПриложения.Авто;
				ИначеЕсли РежимЗапуска=Перечисления.РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение Тогда
					ПользовательИБ.РежимЗапуска=РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение;
				Иначе
					ПользовательИБ.РежимЗапуска=РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение;
				КонецЕсли;
				Если ЕстьФлагЗащитаОтОпасныхДействий=Истина Тогда
					ПользовательИБ.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = ЗащитаОтОпасныхДействий;
				КонецЕсли;
				
				ПользовательИБ.Записать(); 
			Иначе
				Сообщить("Не найден пользователи ИБ по идентификатору!");
			КонецЕсли; 
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьТаблицуПравПользователяИБ();
	
КонецПроцедуры


Процедура ОбновитьТаблицуПравПользователяИБ(ПользовательИБ=Неопределено)

	ТаблицаПрав = Неопределено;
	Если ДополнительныеСвойства.Свойство("ТаблицаПрав",ТаблицаПрав) Тогда
		
		// записшем роли, если нужно, тупо потом отрефакторим
		Если ПользовательИБ=Неопределено Тогда
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
		КонецЕсли;
		
		Если НЕ ПользовательИБ=Неопределено Тогда
			ЕстьИзменения = Ложь;
			МассивРолейДобавить = новый Массив;
			МассивРолейУдалить = новый Массив;
			Для каждого стр из ТаблицаПрав Цикл
				Для каждого Роль из ПользовательИБ.Роли Цикл
					Если стр.Выбрана=Ложь И стр.Имя=Роль.Имя Тогда
						МассивРолейУдалить.Добавить(Роль);
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Для каждого Роль из Метаданные.Роли Цикл
					Если стр.Выбрана=Истина И стр.Имя=Роль.Имя Тогда
						МассивРолейДобавить.Добавить(стр);
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			
			
			// удаляем
			Для каждого стр из МассивРолейУдалить Цикл
				ЕстьИзменения = Истина;
				ПользовательИБ.Роли.Удалить(стр);	
			КонецЦикла;
			// добавляем
			Для каждого стр из МассивРолейДобавить Цикл
				ЕстьИзменения = Истина;
				ПользовательИБ.Роли.Добавить(Метаданные.Роли[стр.Имя]);
			КонецЦикла;
			
			
			Если ЕстьИзменения=Истина Тогда
				ПользовательИБ.Записать();
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЕсли;
КонецПроцедуры



Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);	
	Если НЕ ПользовательИБ=Неопределено Тогда
		ПользовательИБ.Удалить();
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИдентификаторПользователяИБ = Неопределено;
	ИдентификаторПользователяСервиса = Неопределено;
	
	Комментарий = "";
	
КонецПроцедуры



#КонецЕсли