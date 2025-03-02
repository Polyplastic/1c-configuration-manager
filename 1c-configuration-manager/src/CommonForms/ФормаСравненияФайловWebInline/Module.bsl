&НаКлиенте 
Перем ПозицииЯкорей;
&НаКлиенте 
Перем ПозицииПроблем;
&НаКлиенте
Перем ПозицииФункций;  
&НаКлиенте
Перем ПозицииUID;
&НаКлиенте
Перем ИменаФункций;

#Область ИнициализацияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// получаем параметры

	Если Параметры.Свойство("Ключ") Тогда
		Ключ = Параметры.Ключ;
	КонецЕсли;   
	
	Если ЗначениеЗаполнено(Параметры.Сценарий) Тогда
		Сценарий = Параметры.Сценарий;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокФормы") Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	ИначеЕсли ЗначениеЗаполнено(Ключ) Тогда
		Заголовок = Ключ;
	КонецЕсли;  
	
	Если Параметры.Свойство("КлючФормы") Тогда
		КлючФормы = Параметры.КлючФормы;
	КонецЕсли;
		
	Если Параметры.Свойство("АдресВоВременномХранилище") Тогда
		ПолучитьДанныеИзВременногоХранилищац(Параметры.АдресВоВременномХранилище);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИнициализацияНеобходимыхДанных(); 
	ВидНавигацииПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ИнициализацияНеобходимыхДанных()
	
	КоличествоЯкорей = 0;
	КоличествоПроблем = 0;
	ПозицииЯкорей = Новый Соответствие();	
	ПозицииПроблем = Новый Соответствие();
	ПозицииФункций = Новый Соответствие();
	ПозицииUID = Новый Соответствие();
	ИменаФункций = Новый Соответствие();
	ТекстОбработан = Ложь;
	Макет = ПолучитьМакетНаСервере("WebViewOneColumn");
	WEB = Макет.ПолучитьТекст();
	
	Если НЕ ЗначениеЗаполнено(ВидНавигации) Тогда
		ВидНавигации="Изменения";
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура WEBДокументСформирован(Элемент)
	СформироватьРезультатСравненияInline();
КонецПроцедуры


#КонецОбласти      

#Область Навигация

&НаКлиенте
Функция ПолучитьКодПереходаКМетке(Знач Метка,Знач ИндексМетки)
	
	html = "toAnchor('"+Метка+ИндексМетки+"');";
	
	Возврат html;
	
КонецФункции

&НаКлиенте
Процедура down_to_change(Команда)
	
	ИндексМетки = "";
	Если ВидНавигации="Изменения" Тогда
		Метка = "anchor_";	
		Если ТекущаяМетка<КоличествоЯкорей Тогда
			ТекущаяМетка = ТекущаяМетка+1;
		КонецЕсли;      
		Позиция = ТекущаяМетка;
		ИндексМетки = Позиция-1;  
	ИначеЕсли ВидНавигации="Проблемы" Тогда         
		Метка = "anchor_prob_";			
		Если ТекущаяПроблема<КоличествоПроблем Тогда
			ТекущаяПроблема = ТекущаяПроблема+1;
		КонецЕсли;             
		Позиция = ТекущаяПроблема;   
		ИндексМетки = Позиция-1;
	Иначе                     
		Если Элементы.СписокФункций.СписокВыбора.Количество()=0 Тогда
			Возврат;
		КонецЕсли;
		Метка = "anchor_func_";	
		Если ТекущаяФункция<Элементы.СписокФункций.СписокВыбора.Количество()-1 Тогда
			ТекущаяФункция = ТекущаяФункция+1;                              
		Иначе             
			ТекущаяФункция = Элементы.СписокФункций.СписокВыбора.Количество()-1;
		КонецЕсли;
		Позиция = ТекущаяФункция;		
		СтрокаВыбора = Элементы.СписокФункций.СписокВыбора.Получить(Позиция); 
		Если НЕ СтрокаВыбора=Неопределено Тогда
			ИндексМетки = СтрокаВыбора.Значение;
			СписокФункций = СтрокаВыбора.Значение;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьПеремещениеОкнаДляHTML(ИндексМетки, Метка);
	
	// отправим сообщение в другое окно
	ОтправитьСообщениеПоРезультатамНавигации(ВидНавигации,Метка,ИндексМетки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПеремещениеОкнаДляHTML(Знач ИндексМетки, Знач Метка)
	
	Попытка
		Элементы.WEB.Документ.defaultView.exec(ПолучитьКодПереходаКМетке(Метка,ИндексМетки));
		ВыводИмениФункции = ИменаФункций.Получить(Метка+ИндексМетки);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;

КонецПроцедуры   


&НаКлиенте
Процедура up_to_change(Команда)
	
	ИндексМетки="";
	
	Если ВидНавигации="Изменения" Тогда
		Метка = "anchor_";			
		Если ТекущаяМетка>1 Тогда
			ТекущаяМетка = ТекущаяМетка-1;
		КонецЕсли;      
		Позиция = ТекущаяМетка;
		ИндексМетки = Позиция-1;
	ИначеЕсли ВидНавигации="Проблемы" Тогда         
		Метка = "anchor_prob_";			
		Если ТекущаяПроблема>1 Тогда
			ТекущаяПроблема = ТекущаяПроблема-1;
		КонецЕсли;      
		Позиция = ТекущаяПроблема;
		ИндексМетки = Позиция-1;
	Иначе                      
		Если Элементы.СписокФункций.СписокВыбора.Количество()=0 Тогда
			Возврат;
		КонецЕсли;
		Метка = "anchor_func_";	
		Если ТекущаяФункция>0 Тогда
			ТекущаяФункция = ТекущаяФункция-1;                              
		Иначе             
			ТекущаяФункция = 0;
		КонецЕсли;                  
		Если ТекущаяФункция>Элементы.СписокФункций.СписокВыбора.Количество()-1 Тогда
			ТекущаяФункция = 0;
		КонецЕсли;		
		Позиция = ТекущаяФункция;		
		СтрокаВыбора = Элементы.СписокФункций.СписокВыбора.Получить(Позиция); 
		Если НЕ СтрокаВыбора=Неопределено Тогда
			ИндексМетки = СтрокаВыбора.Значение;
			СписокФункций = СтрокаВыбора.Значение;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьПеремещениеОкнаДляHTML(ИндексМетки, Метка);
	
	// отправим сообщение в другое окно
	ОтправитьСообщениеПоРезультатамНавигации(ВидНавигации,Метка,ИндексМетки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФункцийПриИзменении(Элемент)
	Метка = "anchor_func_";	
	ИндексМетки = СписокФункций;      
	
	ВыполнитьПеремещениеОкнаДляHTML(ИндексМетки, Метка);

	// отправим сообщение в другое окно
	ОтправитьСообщениеПоРезультатамНавигации(ВидНавигации,Метка,ИндексМетки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяМеткаПриИзменении(Элемент)    
	
	ПриИзмененииПозицииЯкоря();

КонецПроцедуры           

&НаКлиенте
Процедура ТекущаяПроблемаПриИзменении(Элемент)
	
	ПриИзмененииПозицииЯкоря();
	
КонецПроцедуры


&НаКлиенте
Процедура ПриИзмененииПозицииЯкоря()
	
	Перем Метка, Позиция;
	
	Если ВидНавигации="Изменения" Тогда
		Метка = "anchor_";		
		Если ТекущаяМетка>КоличествоЯкорей Тогда
			ТекущаяМетка = КоличествоЯкорей;
		ИначеЕсли ТекущаяМетка<1 Тогда
			ТекущаяМетка=1;	
		КонецЕсли;      
		Позиция = ТекущаяМетка;
		ИндексМетки = Позиция-1;
	Иначе
		Метка = "anchor_prob_";		
		Если ТекущаяПроблема>КоличествоПроблем Тогда
			ТекущаяПроблема = КоличествоПроблем;
		ИначеЕсли ТекущаяПроблема<1 Тогда
			ТекущаяПроблема=1;	
		КонецЕсли;      
		Позиция = ТекущаяМетка;
		ИндексМетки = Позиция-1;
	КонецЕсли;
	
	Попытка
		Элементы.WEB.Документ.defaultView.exec(ПолучитьКодПереходаКМетке(Метка,ИндексМетки));
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;   
	
	// отправим сообщение в другое окно
	ОтправитьСообщениеПоРезультатамНавигации(ВидНавигации,Метка,ИндексМетки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСообщениеПоРезультатамНавигации(ВидМетки,Метка,ИндексМетки)
	
	мПараметр = Новый Структура();
	мПараметр.Вставить("Ключ",Ключ);  
	мПараметр.Вставить("ВидМетки",ВидМетки);   
	мПараметр.Вставить("Метка",Метка);   
	мПараметр.Вставить("КлючФормы",КлючФормы);
	
	Если ВидМетки="Функции" Тогда
		мПараметр.Вставить("ИмяФункции",СписокФункций);     
	Иначе	
		UID = ПозицииUID.Получить(Метка+ИндексМетки);
		мПараметр.Вставить("UID",UID);
	КонецЕсли;
	
	Оповестить("html_navigate_compare_form",мПараметр,ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Формирование

&НаКлиенте
Процедура СформироватьРезультатСравненияInline()
	TextHtml = "";
	TextHtml2 = "";
	TextHtmlLines = "";
	
	ПолеРедактора1 = Элементы.WEB.Документ.getElementById("ex1");
	ПолеРедактора0 = Элементы.WEB.Документ.getElementById("ex0");

	Если ПолеРедактора1=Неопределено Тогда                          
		Возврат;
	КонецЕсли;
	
	Если ТекстОбработан=Истина Тогда
		Возврат;
	КонецЕсли;
	
	ReplaceInTwo = Истина;
	
	КоличествоЯкорей = 0;
	ПозицииЯкорей = новый Соответствие();
	
	КоличествоПроблем = 0;
	ПозицииПроблем = новый Соответствие(); 
	
	ПозицииФункций = Новый Соответствие(); 
	
	ПозицииUID = Новый Соответствие();
	
	ИменаФункций = Новый Соответствие();
	
	МассивСтрокДокумента = Новый Массив;
	
	Замер = ТекущаяДата();
	
	TextHtmlLines = TextHtmlLines + "<table cellspacing=""0px"" cellpadding=""0px"">";
	//TextHtml = TextHtml + "<table cellspacing=""0px"" cellpadding=""0px"">";
	МассивСтрокДокумента.Добавить("<table cellspacing=""0px"" cellpadding=""0px"">");

	шаг = 0;   
	счетчик_перв = 0;
	счетчик_втор = 0;
	LastStatus=Неопределено;    
	LastFunc=Неопределено;
	LastUID=Неопределено;        
	LastButton=Неопределено;        
	стр_след = Неопределено;
	стр=Неопределено;
	Для Каждого стр из ТаблицаДанных Цикл        
			AnchorHtml = "";
			AnchorProblemHtml = "";
			AnchorFuncNameHtml = "";
			AnchorUIDHtml = "";     
			ButtonHtml="";

			bgcolor = "";   
			fontcolor = "";    
			bgborder = "";   
			bgproblem = "";
			titleproblem = "";        
			
			// метки функций для позиционирования
			Если НЕ LastFunc=стр.ИмяФункции И ЗначениеЗаполнено(стр.ИмяФункции) Тогда
				LastFunc=стр.ИмяФункции;
				AnchorFuncNameHtml = " id='anchor_func_"+Строка(стр.ИмяФункции)+"' ";              
				ПозицииФункций.Вставить(стр.ИмяФункции,"anchor_func_"+Строка(стр.ИмяФункции)+"");
			КонецЕсли;          
			
			// метки для позиционирования между окнами
			Если (стр.ТипИзменений="rep" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Замена")
				ИЛИ стр.ТипИзменений="ins" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Вставка")
				ИЛИ стр.ТипИзменений="del" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Удаление"))
				И НЕ LastUID=стр.UID  Тогда
				AnchorUIDHtml = "<div id='anchor_uid_"+Строка(стр.UID)+"' ></div>";
				LastUID=стр.UID;
			КонецЕсли;
			
			
			// управляем якорями
			Если (стр.ТипИзменений="rep" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Замена")
				ИЛИ стр.ТипИзменений="ins" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Вставка")
				ИЛИ стр.ТипИзменений="del" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Удаление"))
				И НЕ LastStatus=стр.ТипИзменений Тогда
				AnchorHtml = " id='anchor_"+Строка(КоличествоЯкорей)+"' ";
				ПозицииЯкорей.Вставить("anchor_"+Строка(КоличествоЯкорей),шаг-1);
				ПозицииUID.Вставить("anchor_"+Строка(КоличествоЯкорей),стр.UID);
				ИменаФункций.Вставить("anchor_"+Строка(КоличествоЯкорей),стр.ИмяФункции);
				КоличествоЯкорей = КоличествоЯкорей + 1;
				LastStatus=стр.ТипИзменений;
			ИначеЕсли НЕ LastStatus=стр.ТипИзменений Тогда
				LastStatus=стр.ТипИзменений;
			КонецЕсли;
			
			
			// опредееляем оформление типа вставки
			Если стр.ТипИзменений="rep" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Замена") тогда
				bgcolor = "background-color: #CC8877;";
			ИначеЕсли стр.ТипИзменений="ins" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Вставка") Тогда
				bgcolor = "background-color: #AAEE99;";
			ИначеЕсли стр.ТипИзменений="del" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Удаление") Тогда
				bgcolor = "background-color: #AA8866;";
			КонецЕсли;           
			
			// определяем оформление проблемы  
			Если стр.ТипПроблемы="err" ИЛИ стр.ТипПроблемы=ПредопределенноеЗначение("Перечисление.ТипыПроблем.Ошибка") Тогда
				bgborder = "border-left: 2px solid #ff4a4a;";
				bgproblem = "<span title='"+стр.Проблема+"' style='color:#ff4a4a;'>&#9940;<span>";
				titleproblem = стр.Проблема;                      
			ИначеЕсли стр.ТипПроблемы="war" ИЛИ стр.ТипПроблемы=ПредопределенноеЗначение("Перечисление.ТипыПроблем.Предупреждение") Тогда
				bgborder = "border-left: 2px solid #FFA500;";
				bgproblem = "<span title='"+стр.Проблема+"'  style='color:#FFA500;'>&#9888;<span>";
				titleproblem = стр.Проблема;    
			КонецЕсли;
			
			Если НЕ LastButton=стр.UID 
				И ((стр.ТипПроблемы="err" ИЛИ стр.ТипПроблемы=ПредопределенноеЗначение("Перечисление.ТипыПроблем.Ошибка"))
				ИЛИ	(стр.ТипПроблемы="war" ИЛИ стр.ТипПроблемы=ПредопределенноеЗначение("Перечисление.ТипыПроблем.Предупреждение"))) Тогда       
				
				AnchorProblemHtml = " id='anchor_prob_"+Строка(КоличествоПроблем)+"' ";
				LastButton=стр.UID;
				ButtonHtml = "<button name='setOk' id='"+стр.UID+"' onclick='setOk("""+стр.UID+""")'>Ok</button>
							|<button name='showCode' id='"+стр.UID+"' >Code</button>";
				
				ПозицииПроблем.Вставить("anchor_prob_"+Строка(КоличествоПроблем),шаг-1);
				ПозицииUID.Вставить("anchor_prob_"+Строка(КоличествоПроблем),стр.UID);
				ИменаФункций.Вставить("anchor_prob_"+Строка(КоличествоПроблем),стр.ИмяФункции);
				КоличествоПроблем = КоличествоПроблем+1;				
			КонецЕсли;
			
			стр_счетчик_перв="";
			стр_счетчик_втор=""; 
			// определяем счетчик
			Если стр.ТипИзменений="del" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Удаление") Тогда          
				счетчик_перв = счетчик_перв+1;
				стр_счетчик_перв = счетчик_перв;
			ИначеЕсли стр.ТипИзменений="ins"  ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Вставка") Тогда
				счетчик_втор = счетчик_втор+1;  
				стр_счетчик_втор = счетчик_втор;
			Иначе
				счетчик_перв = счетчик_перв+1;
				счетчик_втор = счетчик_втор+1;
				стр_счетчик_перв = счетчик_перв;
				стр_счетчик_втор = счетчик_втор;
			КонецЕсли;
			
			
			DeleteSourceTag = "";
			AddDestinationTag = "";
			
			Если стр.ТипИзменений="del"  ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Удаление") Тогда
				DeleteSourceTag = "---";
			КонецЕсли;
			
			Если стр.ТипИзменений="ins" ИЛИ стр.ТипИзменений = ПредопределенноеЗначение("Перечисление.ТипыИзменений.Вставка") Тогда
				AddDestinationTag = "+++";
			КонецЕсли;
			
			МассивСтрокДокумента.Добавить("<tr>");
			МассивСтрокДокумента.Добавить("<td "+AnchorHtml+">"+bgproblem+"</td><td align='right'>"+стр_счетчик_перв+"&nbsp;</td><td align='right' style='border-left: 2px solid #afafaf;'>"+стр_счетчик_втор+"&nbsp;</td>");
			text = ОформлениеКода1С.РаскраситьКод1С8(стр.Текст);
			//text = Заменить_СпецСимволы_На_БезопасныйКод(text);
			text = ?(ЗначениеЗаполнено(text),text," ");       
			//Если Лев(СокрЛП(text),2)="//" Тогда
			//	fontcolor = "color: #307640;";
			//КонецЕсли;
			status = стр.ТипИзменений;   
			МассивСтрокДокумента.Добавить("<td style='border-left: 2px solid #afafaf;'>"+AnchorUIDHtml+DeleteSourceTag+AddDestinationTag+"&nbsp;</td>");
			МассивСтрокДокумента.Добавить("<td "+AnchorProblemHtml+" >"+ButtonHtml+"</td>");
			МассивСтрокДокумента.Добавить("<td "+AnchorFuncNameHtml+" style='border-left: 2px solid #cfcfcf;"+bgcolor+fontcolor+bgborder+"' title='"+titleproblem+"'>"+text+"</td></tr>");
		
	КонецЦикла;
	
		
	МассивСтрокДокумента.Добавить("</table>");
	TextHtmlLines = TextHtmlLines + "</table>";
	
	Если ПолеРедактора1<>Неопределено Тогда
		ПолеРедактора1.innerHTML = СтрСоединить(МассивСтрокДокумента,Символы.ПС);		
	КонецЕсли;
	
	Если  ПолеРедактора0<>Неопределено Тогда
		ПолеРедактора0.innerHTML = TextHtmlLines;		
	КонецЕсли;
	
	//Сообщить("Время генерации html: "+(ТекущаяДата()-Замер));
	ТекстОбработан = Истина;      
	
	Для каждого стр из ПозицииФункций Цикл
		Элементы.СписокФункций.СписокВыбора.Добавить(стр.Ключ);
	КонецЦикла;   
	
	КоличествоФункций = ПозицииФункций.Количество();
	
КонецПроцедуры


#КонецОбласти


#Область СлужебныеФункции

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
		Макет = ПолучитьОбщийМакет(ИмяМакета);
	Исключение
		Сообщить(ОписаниеОшибки());		
	КонецПопытки;
	Возврат Макет;
КонецФункции



&НаСервере
Процедура ПолучитьДанныеИзВременногоХранилищац(АдресВоВременномХранилище)
	
	мСтруктура = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Если мСтруктура=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	
	ш=1;
	Для каждого стр из мСтруктура.МассивДанных Цикл
		МассивСтрок = СтрРазделить(стр.Текст,Символы.ПС,Истина);
		Для каждого кода_строка Из  МассивСтрок Цикл
			стр_н = ТаблицаДанных.Добавить();
			стр_н.ТипИзменений = стр.ТипИзменений;
			стр_н.Проблема = стр.Проблема;
			стр_н.ТипПроблемы = стр.ТипПроблемы;
			стр_н.Текст = кода_строка;                        
			стр_н.НомерСтроки = ш;
			стр.Свойство("ИмяФункции",стр_н.ИмяФункции);
			стр.Свойство("UID",стр_н.UID);
			ш=ш+1;
		КонецЦикла;
	КонецЦикла;
	
	
КонецПроцедуры

// Функция - Заменить спец символы на безопасный код
//
// Параметры:
//  Текст	 - строка	 - исходная строка
// 
// Возвращаемое значение:
//  стрка - обработанное значение
//
&НаКлиенте
Функция Заменить_СпецСимволы_На_БезопасныйКод(Знач Текст)
	Текст = СтрЗаменить(Текст,"&","&amp;");
	Текст = СтрЗаменить(Текст,"<","&lt;");
	Текст = СтрЗаменить(Текст,">","&gt;");
	//Текст = СтрЗаменить(Текст," ","&nbsp;");
	Возврат Текст;
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	мКлючФормы = "";
	Если Тип("Структура")=ТипЗнч(Параметр) И Параметр.Свойство("КлючФормы") Тогда
		мКлючФормы = Параметр.КлючФормы;
	КонецЕсли;
	
	Если ИмяСобытия="diff_изменение" И мКлючФормы=КлючФормы Тогда
		// получаем параметры
		Если Параметр.Свойство("АдресВоВременномХранилище") Тогда
			Попытка
				ПолучитьДанныеИзВременногоХранилищац(Параметр.АдресВоВременномХранилище);
				ИнициализацияНеобходимыхДанных();				
			Исключение
			КонецПопытки;
		КонецЕсли;
	ИначеЕсли ИмяСобытия="html_navigate_compare_form" 
		И Тип("Структура")=ТипЗнч(Параметр) 
		И Параметр.Свойство("КлючФормы")  И НЕ Параметр.КлючФормы=КлючФормы 
		И Параметр.Свойство("Ключ") И Параметр.Ключ=Ключ Тогда
		
		// переход по функцииям html
		Если Параметр.Свойство("ИмяФункции") Тогда
			
			ВыполнитьПеремещениеОкнаДляHTML(Параметр.ИмяФункции, Параметр.Метка);
			
		ИначеЕсли Параметр.Свойство("UID") Тогда
			
	        ВыполнитьПеремещениеОкнаДляHTML(Параметр.UID, "anchor_uid_");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНавигацииПриИзменении(Элемент)
	Если ВидНавигации="Изменения" Тогда
		Элементы.ГруппаПроблемы.Видимость=Ложь;
		Элементы.ГруппаЯкоря.Видимость=Истина;
		Элементы.ГруппаФункции.Видимость=Ложь;
	ИначеЕсли ВидНавигации="Проблемы" Тогда
		Элементы.ГруппаПроблемы.Видимость=Истина;
		Элементы.ГруппаЯкоря.Видимость=Ложь;
		Элементы.ГруппаФункции.Видимость=Ложь;
	Иначе
		Элементы.ГруппаПроблемы.Видимость=Ложь;
		Элементы.ГруппаЯкоря.Видимость=Ложь;  
		Элементы.ГруппаФункции.Видимость=Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура WEBПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	// получаем позицию нажатия мышкой
	// нам пришло сообщение поставить ок
	Если НЕ ДанныеСобытия.Element=Неопределено И ДанныеСобытия.Element.name="setOk" Тогда
		UID = СокрЛП(ДанныеСобытия.Element.id);	
		ОбработкаИзмененийКонфигурацийВызовСервера.ПроставитьСтатусОбработаноПоUID(Сценарий,Ключ,UID);		
		// изменим элемент
		ДанныеСобытия.Element.style="background:green;";
	ИначеЕсли  НЕ ДанныеСобытия.Element=Неопределено И ДанныеСобытия.Element.name="showCode" Тогда
		UID = СокрЛП(ДанныеСобытия.Element.id);	
		ПоказатьИсходныйКод(UID);
	КонецЕсли;
	
КонецПроцедуры         

&НаКлиенте
Процедура ПоказатьИсходныйКод(UID)
	
	мОтбор = Новый Структура("UID",UID);
	н_строки = ТаблицаДанных.НайтиСтроки(мОтбор);  
	
	ДанныеФайла = Новый Массив;
	Для каждого стр из н_строки Цикл
		СтруктураСтроки = Новый Структура("Текст,ТипИзменений,ИмяФункции,ТипПроблемы,Проблема,Длина,UID");
		ЗаполнитьЗначенияСвойств(СтруктураСтроки,стр);
		ДанныеФайла.Добавить(СтруктураСтроки);
	КонецЦикла;
	
	ТекстФайла = ""; 
	МассивСтрок = Новый Массив;
	// формируем файл
	Для каждого стр из ДанныеФайла Цикл
		МассивСтрок.Добавить(стр.Текст);
	КонецЦикла;                         
	ТекстФайла = СтрСоединить(МассивСтрок,Символы.ПС);
	
	КлючФормы = Новый UUID();
	мПараметры = новый Структура();
	мПараметры.Вставить("ТекстФайла",ТекстФайла);
	мПараметры.Вставить("КлючФормы",КлючФормы);
	мПараметры.Вставить("ЗаголовокФормы","исходный: "+Ключ+"");
	мПараметры.Вставить("Ключ",Ключ);
	мПараметры.Вставить("Сценарий",Сценарий);
	
	Форма = ПолучитьФорму("ОбщаяФорма.ФормаРедактированияКода1С",мПараметры,ЭтаФорма,КлючФормы);	
	
	Форма.Открыть();
КонецПроцедуры



#КонецОбласти
