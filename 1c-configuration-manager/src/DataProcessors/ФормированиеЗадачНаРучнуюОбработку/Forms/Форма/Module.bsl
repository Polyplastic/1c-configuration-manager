
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗадачиНаОбработкуПроблем(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мПараметры = Новый Структура;
	мПараметры.Вставить("Сценарий",ТекущиеДанные.Сценарий);
	Форма = ПолучитьФорму("Обработка.ФормированиеЗадачНаРучнуюОбработку.Форма.ФормаСоздатьЗадачиНаОбработкуПроблемы",мПараметры,ЭтаФорма);
	Форма.Открыть();
	
КонецПроцедуры


&НаКлиенте
Процедура НазначитьПользователейПоНаборуКлючей(Команда)   
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мПараметры = Новый Структура;
	мПараметры.Вставить("Сценарий",ТекущиеДанные.Сценарий);
	Форма = ПолучитьФорму("Обработка.ФормированиеЗадачНаРучнуюОбработку.Форма.ФормаПереназначитьЗадачиПоТекстовомуСпискуКлючей",мПараметры,ЭтаФорма);
	Форма.Открыть();    
	
КонецПроцедуры

