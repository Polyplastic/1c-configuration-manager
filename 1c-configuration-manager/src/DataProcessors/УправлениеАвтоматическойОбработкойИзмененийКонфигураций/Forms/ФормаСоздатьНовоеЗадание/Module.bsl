
&НаСервере
Процедура СоздатьНовоеЗаданиеНаСервере()       
	
	Если НЕ ЗначениеЗаполнено(Сценарий) Тогда
		Сообщить("Укажите сценарий прежде!");
		Возврат;
	КонецЕсли;
	
	ОбработкаИзмененийКонфигурацийСервер.СоздатьНовоеЗадание(Сценарий);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовоеЗадание(Команда)
	СоздатьНовоеЗаданиеНаСервере();   
	ЭтаФорма.Закрыть();
КонецПроцедуры
