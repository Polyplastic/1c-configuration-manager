
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

КонецПроцедуры

&НаКлиенте
Процедура КонструкторЗапроса(Команда)
	
	КонструкторЗапроса = Новый КонструкторЗапроса();
	КонструкторЗапроса.Текст = Объект.ТекстЗапроса;
	
	ДопПараметры = Новый Структура();
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаТекстаЗапроса",ЭтаФорма,ДопПараметры);
	КонструкторЗапроса.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаТекстаЗапроса(Текст,ДополнительныеПараметры) Экспорт
	Если Текст=Неопределено Тогда
		Возврат;
	КонецЕсли;   
	
	Объект.ТекстЗапроса = Текст;
	
КонецПроцедуры       


&НаКлиенте
Процедура ТребуемыеИсточникиДанныхИсточникДанныхПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТребуемыеИсточникиДанных.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;  
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ИсточникДанных) Тогда
		Возврат;
	КонецЕсли;
	
	// получим базу по умолчанию, если есть
	ТекущиеДанные.БазаДанных = ОбщегоНазначенияВызовСервера.ЗначениеРеквизитаОбъекта(ТекущиеДанные.ИсточникДанных,"БазаДанных");
	
КонецПроцедуры

