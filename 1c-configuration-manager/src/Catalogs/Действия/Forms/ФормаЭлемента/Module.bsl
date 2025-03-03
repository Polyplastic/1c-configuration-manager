
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	HTML_поле = ПолучитьОбщийМакет("HTML_Editor").ПолучитьТекст();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)      
	
	Элементы.Формат.СписокВыбора.Добавить("h1","Заголовок 1 <h1>");
	Элементы.Формат.СписокВыбора.Добавить("h2","Заголовок 2 <h2>");
	Элементы.Формат.СписокВыбора.Добавить("h3","Заголовок 3 <h3>");
	Элементы.Формат.СписокВыбора.Добавить("h4","Заголовок 4 <h4>");
	Элементы.Формат.СписокВыбора.Добавить("h5","Заголовок 5 <h5>");
	Элементы.Формат.СписокВыбора.Добавить("h6","Заголовок 6 <h6>");
	Элементы.Формат.СписокВыбора.Добавить("p","Параграф <p>");
	Элементы.Формат.СписокВыбора.Добавить("div","Слой <div>");
	Элементы.Формат.СписокВыбора.Добавить("pre","Преформатированный <pre>");   
	
	ВидимостьКнопок();
	
КонецПроцедуры

#Область Подготовка

// Функция - Получить макет на сервере
//
// Параметры:
//  ИмяМакета	 - строка	 - имя макета
// 
// Возвращаемое значение:
// макет  - макет
//
&НаСервере
Функция ПолучитьМакетНаСервере(ИмяМакета)
	Макет = Неопределено;
	Попытка
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		Макет = ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
	Исключение
		Сообщить(ОписаниеОшибки());		
	КонецПопытки;
	Возврат Макет;
КонецФункции

&НаКлиенте
Функция ПолучитьHTMLView()
	
	Перем htmlView;
	
	htmlView = неопределено;
	Если Элементы.HTML_поле.Документ.parentWindow=Неопределено Тогда
		htmlView = Элементы.HTML_поле.Документ.defaultView;
	Иначе
		htmlView = Элементы.HTML_поле.Документ.parentWindow;
	КонецЕсли;
	Возврат htmlView;

КонецФункции

&НаКлиенте
Процедура FormatDoc(Знач Команда, Знач ДопПараметр=Неопределено)
	htmlView = ПолучитьHTMLView();
	htmlView.formatDoc(Команда,ДопПараметр);
КонецПроцедуры   

&НаКлиенте
Процедура HTML_полеДокументСформирован(Элемент)
	ПанельВHTMLПолеПриИзменении(Неопределено);
	htmlView = ПолучитьHTMLView();
	htmlView.set_text(Объект.HTML);
КонецПроцедуры




#КонецОбласти


#область КомандыФормы

&НаКлиенте
Процедура РежимHTMLПриИзменении(Элемент)
	htmlView = ПолучитьHTMLView();
	htmlView.setDocMode(РежимHTML);
КонецПроцедуры

&НаКлиенте
Процедура ПанельВHTMLПолеПриИзменении(Элемент)
	htmlView = ПолучитьHTMLView(); 
	Если НЕ htmlView=Неопределено Тогда
		htmlView.showHTMLPanel(НЕ ПанельВHTMLПоле);
	КонецЕсли;
	ВидимостьКнопок();
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьКнопок()
	
	Элементы.ГруппаКнопокОсновные.Видимость = НЕ ПанельВHTMLПоле;
	Элементы.ГруппаДополнительно.Видимость = НЕ ПанельВHTMLПоле;

КонецПроцедуры


&НаКлиенте
Процедура Bold(Команда)
	FormatDoc("bold");
КонецПроцедуры

&НаКлиенте
Процедура Italic(Команда)
	FormatDoc("italic");
КонецПроцедуры

&НаКлиенте
Процедура Underline(Команда)
	FormatDoc("underline");
КонецПроцедуры

&НаКлиенте
Процедура Redo(Команда)
	FormatDoc("redo");
КонецПроцедуры

&НаКлиенте
Процедура Undo(Команда)
	FormatDoc("undo");
КонецПроцедуры

&НаКлиенте
Процедура Copy(Команда)
	FormatDoc("copy");
КонецПроцедуры

&НаКлиенте
Процедура Paste(Команда)
	FormatDoc("paste");
КонецПроцедуры

&НаКлиенте
Процедура Cut(Команда)
	FormatDoc("cut");
КонецПроцедуры

&НаКлиенте
Процедура insertorderedlist(Команда)
	FormatDoc("insertorderedlist");
КонецПроцедуры

&НаКлиенте
Процедура insertunorderedlist(Команда)
	FormatDoc("insertunorderedlist");
КонецПроцедуры

&НаКлиенте
Процедура indent(Команда)
	FormatDoc("indent");
КонецПроцедуры

&НаКлиенте
Процедура outdent(Команда)
	FormatDoc("outdent");
КонецПроцедуры

&НаКлиенте
Процедура justifycenter(Команда)
	FormatDoc("justifycenter");
КонецПроцедуры

&НаКлиенте
Процедура justifyleft(Команда)
	FormatDoc("justifyleft");
КонецПроцедуры

&НаКлиенте
Процедура justifyright(Команда)
	FormatDoc("justifyright");
КонецПроцедуры

&НаКлиенте
Процедура unlink(Команда)
	FormatDoc("unlink");
КонецПроцедуры

&НаКлиенте
Процедура createlink(Команда)
	мПараметры = новый Структура("Команда","createlink");
	Форма = ПолучитьФорму("Справочник.МеханизмыКонфигурации.Форма.ФормаСсылки",мПараметры,ЭтаФорма);
	Форма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура insertimage(Команда)
	мПараметры = новый Структура("Команда","insertimage");
	Форма = ПолучитьФорму("Справочник.МеханизмыКонфигурации.Форма.ФормаКартинки",мПараметры,ЭтаФорма);
	Форма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="Editor" Тогда
		
		FormatDoc(Параметр.Команда,Параметр.ДопПараметр);	
		
	ИначеЕсли ИмяСобытия="ImageSize" Тогда
		
		htmlView = ПолучитьHTMLView();
		//htmlView.getCurrentImage();
		htmlView.changeCurrentImageSize(Параметр.Высота,Параметр.Ширина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРазмерыИзображения(Команда)
	
	// получим ссылку на изображение
	htmlView = ПолучитьHTMLView();
	СтрокаJson = htmlView.getPropCurrentImage();
	
	// это не изображение
	Если СтрокаJson=Неопределено или СтрокаJson="" Тогда
		Возврат;
	КонецЕсли;		
	
	Json = новый ЧтениеJSON;
	Json.УстановитьСтроку(СтрокаJson);
	Данные = ПрочитатьJSON( Json ,, "" );
	Json.Закрыть();
	
	
	
	мПараметры = новый Структура("Высота,Ширина,ДопПараметр",Данные.height,Данные.width,Данные.src);
	Форма = ПолучитьФорму("Справочник.МеханизмыКонфигурации.Форма.ФормаИзменитьРазмеры",мПараметры,ЭтаФорма);
	Форма.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ФорматПриИзменении(Элемент)
	
	FormatDoc("formatblock",Формат);	
	ТекущийЭлемент = Элементы.HTML_поле;
	
КонецПроцедуры

&НаКлиенте
Процедура infostart(Команда)
	ЗапуститьПриложение("https://infostart.ru/public/1268943/");
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	htmlView = ПолучитьHTMLView();
	Объект.HTML = htmlView.get_text();
КонецПроцедуры

#КонецОбласти



#Область ОбработкаСобытийHTMLполя
 
#КонецОбласти