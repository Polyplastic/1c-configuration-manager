#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура УстановкаПараметровСеанса(ТребуемыеПараметры)
	
	// получим компьютер
	УстановитьПривилегированныйРежим(Истина);
	
	// Установить пользователя
	ПользователиВызовСервера.УстановитьПараметры(ПараметрыСеанса);
	
	// Установим стиль
	Если ТребуемыеПараметры = Неопределено Тогда
		ПользователиВызовСервера.УстановитьГлавныйСтильИзНастроек();
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли