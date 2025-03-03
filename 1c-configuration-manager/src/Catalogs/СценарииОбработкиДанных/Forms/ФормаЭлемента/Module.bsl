
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

КонецПроцедуры

&НаКлиенте
Процедура КаталогБазоваяНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораФайла.Каталог = Объект.КаталогБазовая;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Объект.КаталогБазовая = ДиалогВыбораФайла.Каталог;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КаталогБазоваяНоваяНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораФайла.Каталог = Объект.КаталогБазоваяНовая;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Объект.КаталогБазоваяНовая = ДиалогВыбораФайла.Каталог;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КаталогИзмененнаяНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораФайла.Каталог = Объект.КаталогИзмененная;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Объект.КаталогИзмененная = ДиалогВыбораФайла.Каталог;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КаталогИзмененнаяНоваяНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораФайла.Каталог = Объект.КаталогИзмененнаяНовая;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Объект.КаталогИзмененнаяНовая = ДиалогВыбораФайла.Каталог;
	КонецЕсли;
КонецПроцедуры


#Область Каталоги



#КонецОбласти