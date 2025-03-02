////////////////////////////////////////////////////////////////////////////////
// Подсистема "Регламентные задания".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает использование регламентного задания.
//  Перед вызовом требуется иметь право Администрирования или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
// Возвращаемое значение:
//  Булево - если Истина, регламентное задание используется.
// 
Функция ПолучитьИспользованиеРегламентногоЗадания(Знач Идентификатор) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Возврат Задание.Использование;
	
КонецФункции

// Устанавливает использование регламентного задания.
//  Перед вызовом требуется иметь право Администрирования или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
// Использование  - Булево - значение использования которое нужно установить.
// 
Процедура УстановитьИспользованиеРегламентногоЗадания(Знач Идентификатор, Знач Использование) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если Задание.Использование <> Использование Тогда
		Задание.Использование = Использование;
	КонецЕсли;
	
	Задание.Записать();
	
КонецПроцедуры

// Возвращает расписание регламентного задания.
//  Перед вызовом требуется иметь право Администрирования или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
//  ВСтруктуре    - Булево - если Истина, тогда расписание будет преобразовано
//                  в структуру, которую можно передать на клиент.
// 
// Возвращаемое значение:
//  РасписаниеРегламентногоЗадания, Структура - структура содержит те же свойства, что и расписание.
// 
Функция ПолучитьРасписаниеРегламентногоЗадания(Знач Идентификатор, Знач ВСтруктуре = Ложь) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если ВСтруктуре Тогда
		Возврат ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Задание.Расписание);
	КонецЕсли;
	
	Возврат Задание.Расписание;
	
КонецФункции

// Устанавливает расписание регламентного задания.
//  Перед вызовом требуется иметь право Администрирования или УстановитьПривилегированныйРежим.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание.
//
//  Расписание    - РасписаниеРегламентногоЗадания - расписание.
//                - Структура - значение возвращаемое функцией РасписаниеВСтруктуру
//                  общего модуля ОбщегоНазначенияКлиентСервер.
// 
Процедура УстановитьРасписаниеРегламентногоЗадания(Знач Идентификатор, Знач Расписание) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = ПолучитьРегламентноеЗадание(Идентификатор);
	
	Если ТипЗнч(Расписание) = Тип("РасписаниеРегламентногоЗадания") Тогда
		Задание.Расписание = Расписание;
	Иначе
		Задание.Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(Расписание);
	КонецЕсли;
	
	Задание.Записать();
	
КонецПроцедуры

// Возвращает РегламентноеЗадание из информационной базы.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                  предопределенного регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - Строка - строка уникального идентификатора регламентного задания.
//                - РегламентноеЗадание - регламентное задание из которого нужно получить
//                  уникальный идентификатор для получения свежей копии регламентного задания.
// 
// Возвращаемое значение:
//  РегламентноеЗадание - прочитано из базы данных.
//
Функция ПолучитьРегламентноеЗадание(Знач Идентификатор) Экспорт
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
		РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Идентификатор);
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	КонецЕсли;
	
	Если РегламентноеЗадание = Неопределено Тогда
		ВызватьИсключение( НСтр("ru = 'Регламентное задание не найдено.
		                              |Возможно, оно удалено другим пользователем.'") );
	КонецЕсли;
	
	Возврат РегламентноеЗадание;
	
КонецФункции

#КонецОбласти
