
&НаКлиенте
Процедура ПоказатьПланируемуюВставку(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;      
	
	ДанныеОтличий = ПолучитьОтличияФайловРасчетИзменений(ТекущиеДанные.Сценарий,ТекущиеДанные.Ключ);
	
	КлючФормы = Новый UUID();	
	мПараметры = новый Структура();
	мПараметры.Вставить("АдресВоВременномХранилище",ПередатьДанныеВоВнешнююФорму(ДанныеОтличий));
	мПараметры.Вставить("diff_api","diff");
	мПараметры.Вставить("diff_inline",Истина);
	мПараметры.Вставить("КлючФормы",КлючФормы);
	мПараметры.Вставить("ЗаголовокФормы","расчет: "+ТекущиеДанные.Ключ+" - текущие отличия");
	мПараметры.Вставить("Ключ",ТекущиеДанные.Ключ);
	мПараметры.Вставить("Сценарий",ТекущиеДанные.Сценарий);
	
	Форма = ПолучитьФорму("ОбщаяФорма.ФормаСравненияФайловWebInline",мПараметры,ЭтаФорма,КлючФормы);	
	
	Форма.Открыть();
	Оповестить("diff_изменение",мПараметры,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Функция ПередатьДанныеВоВнешнююФорму(МассивДанных)
	
	мСтруктура = новый Структура();
	мСтруктура.Вставить("МассивДанных",МассивДанных);

	Возврат ПоместитьВоВременноеХранилище(мСтруктура);
	
КонецФункции


&НаСервереБезКонтекста
Функция ПолучитьОтличияФайловРасчетИзменений(Сценарий,Ключ)
	
	Возврат РегистрыСведений.РасчетИзмененийКонфигураций.ПолучитьОтличияФайловРасчетИзменений(Сценарий,Ключ);
	
КонецФункции


&НаСервереБезКонтекста
Функция ПолучитьОтличияФайловРасчетИзмененийРучнаяПравка(Сценарий,Ключ)
	
	Возврат РегистрыСведений.РасчетИзмененийКонфигурацийРучнаяПравка.ПолучитьОтличияФайловРасчетИзменений(Сценарий,Ключ);
	
КонецФункции

&НаКлиенте
Процедура РедактироватьВручнуюФайл(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;      
	
	ДанныеОтличий = ПолучитьОтличияФайловРасчетИзмененийРучнаяПравка(ТекущиеДанные.Сценарий,ТекущиеДанные.Ключ);
	
	// тогда это новый файл
	Если ДанныеОтличий.Количество()=0 Тогда
		ДанныеОтличий = ПолучитьОтличияФайловРасчетИзменений(ТекущиеДанные.Сценарий,ТекущиеДанные.Ключ);
	КонецЕсли;
	
	ТекстФайла = ""; 
	МассивСтрок = Новый Массив;
	// формируем файл
	Для каждого стр из ДанныеОтличий Цикл
		МассивСтрок.Добавить(стр.Текст);
	КонецЦикла;                         
	ТекстФайла = СтрСоединить(МассивСтрок,Символы.ПС);
	
	КлючФормы = Новый UUID();
	мПараметры = новый Структура();
	мПараметры.Вставить("ТекстФайла",ТекстФайла);
	мПараметры.Вставить("КлючФормы",КлючФормы);
	мПараметры.Вставить("ЗаголовокФормы","правка: "+ТекущиеДанные.Ключ+"");
	мПараметры.Вставить("Ключ",ТекущиеДанные.Ключ);
	мПараметры.Вставить("Сценарий",ТекущиеДанные.Сценарий);
	
	Форма = ПолучитьФорму("ОбщаяФорма.ФормаРедактированияКода1С",мПараметры,ЭтаФорма,КлючФормы);	
	
	Форма.Открыть();
КонецПроцедуры           


