

#Область АлгоритмDiff

&НаКлиенте
Функция _ProcessDiff(source, destination,_level) Экспорт
	
	dt = ТекущаяДата();
	_source = source;
	_dest = destination;
	_matchList = новый Массив;
	
	dcount = _dest.Count();
	scount = _source.Count();	
	
	Если ((dcount > 0)И(scount > 0)) Тогда
		_stateList = новый Массив(dcount);
		_ProcessRange(0,dcount - 1,0, scount - 1,_stateList,_level,_source,_dest,_matchList);
	КонецЕсли;
	
	ts = ТекущаяДата() - dt;
	Возврат новый Структура("ts,_source,_dest,_stateList,_matchList",ts,_source,_dest,_stateList,_matchList);	
КонецФункции  

&НаКлиенте
Функция DiffList_Text(text) Экспорт
	_lines = новый Массив;
	
	МассивСтрок = новый Массив;
	МассивСтрок = СтрРазделить(text,Символы.ПС,Истина);
	
	
	Для ш=0 по МассивСтрок.Количество()-1 Цикл
		строка = МассивСтрок[ш];
		_lines.Добавить(TextLine(строка));
	КонецЦикла;
	
	Возврат _lines;
КонецФункции

&НаКлиенте
Процедура _ProcessRange(destStart, destEnd, sourceStart, sourceEnd, 
	// поля структуры
	_stateList,_level,_source,_dest,_matchList)

	curBestIndex = -1;
	curBestLength = -1;
	maxPossibleDestLength = 0;
	curItem = Неопределено;
	bestItem = Неопределено;
	destIndex = destStart;
	
	Пока  destIndex <= destEnd Цикл			
		maxPossibleDestLength = (destEnd - destIndex) + 1;
		Если  (maxPossibleDestLength <= curBestLength) Тогда
			//we won't find a longer one even if we looked
			break;
		КонецЕсли;
		
		curItem = _stateList_GetByIndex(destIndex, _stateList);
		
		Если (_HasValidLength(sourceStart, sourceEnd, maxPossibleDestLength,curItem)<>Истина) Тогда 			
			//recalc new best length since it isn't valid or has never been done.
			GetLongestSourceMatch(curItem, destIndex, destEnd, sourceStart, sourceEnd, _source, _dest);
		КонецЕсли;
		
		Если (curItem.Status = DiffStatus_Получить("Matched")) Тогда
			
			Если _level="fast" Тогда 				
				
				Если (curItem._length > curBestLength) Тогда
					
					//this is longest match so far
					curBestIndex = destIndex;
					curBestLength = curItem._length;
					bestItem = curItem;
				КонецЕсли;
				
				//Jump over the match 
				destIndex = destIndex + curItem._length - 1; 
				
			ИначеЕсли _level="medium" Тогда 
				Если (curItem._length > curBestLength)  Тогда
					
					//this is longest match so far
					curBestIndex = destIndex;
					curBestLength = curItem._length;
					bestItem = curItem;
					//Jump over the match 
					destIndex = destIndex + curItem._length - 1; 
				КонецЕсли;
				
			Иначе
				Если (curItem._length > curBestLength) Тогда
					//this is longest match so far
					curBestIndex = destIndex;
					curBestLength = curItem._length;
					bestItem = curItem;
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		destIndex = destIndex+1;
	КонецЦикла;	
	
	Если (curBestIndex < 0) Тогда
		
		//we are done - there are no matches in this span
	Иначе
		
		sourceIndex = bestItem._startIndex;
		_matchList.Add(CreateNoChange(curBestIndex,sourceIndex,curBestLength));
		
		Если (destStart < curBestIndex) Тогда
			
			//Still have more lower destination data
			Если (sourceStart < sourceIndex) Тогда
				
				//Still have more lower source data
				// Recursive call to process lower indexes
				_ProcessRange(destStart, curBestIndex -1,sourceStart, sourceIndex -1, _stateList,_level,_source,_dest,_matchList);
			КонецЕсли;
		КонецЕсли;
		
		upperDestStart = curBestIndex + curBestLength;
		upperSourceStart = sourceIndex + curBestLength;
		
		Если (destEnd >= upperDestStart) Тогда
			
			//we still have more upper dest data
			Если (sourceEnd >= upperSourceStart) Тогда
				
				//set still have more upper source data
				// Recursive call to process upper indexes
				_ProcessRange(upperDestStart, destEnd, upperSourceStart, sourceEnd, _stateList,_level,_source,_dest,_matchList);
			КонецЕсли;
		КонецЕсли
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура GetLongestSourceMatch(curItem,  destIndex, destEnd,  sourceStart, sourceEnd,
	// поля структуры
	_source,_dest)
	
	maxDestLength = (destEnd - destIndex) + 1;
	curLength = 0;
	curBestLength = 0;
	curBestIndex = -1;
	maxLength = 0;
	
	sourceIndex = sourceStart;
	Пока  (sourceIndex <= sourceEnd) Цикл
		
		maxLength = Min(maxDestLength,(sourceEnd - sourceIndex) + 1);
		Если (maxLength <= curBestLength) Тогда
			//No chance to find a longer one any more
			Прервать;
		КонецЕсли;
		curLength = GetSourceMatchLength(destIndex,sourceIndex,maxLength, _source,_dest);
		Если (curLength > curBestLength) Тогда
			//This is the best match so far
			curBestIndex = sourceIndex;
			curBestLength = curLength;
		КонецЕсли;
		//jump over the match
		sourceIndex = sourceIndex + 1 + curBestLength; 
	КонецЦикла;
	
	Если (curBestIndex = -1) Тогда			
		_SetNoMatch(curItem);			
	Иначе			
		_SetMatch(curBestIndex, curBestLength, curItem);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Функция GetSourceMatchLength(destIndex, sourceIndex, maxLength,
	// структура
	_source,_dest)
	
	matchCount =0;
	//Для matchCount = 0 по matchCount < maxLength Цикл 
	Пока (matchCount < maxLength) Цикл
		Если ( CompareTo(_GetByIndex(destIndex + matchCount,_dest),(_GetByIndex(sourceIndex + matchCount,_source))) <> 0 ) Тогда
			Прервать;
		КонецЕсли;
		matchCount = matchCount+1;
	КонецЦикла;
	Возврат matchCount;
КонецФункции

#Область ВспомогательныеФункции

&НаКлиенте
Функция TextLine(str,ОтложенныйХеш=Истина)
	мРез = новый Структура();
	
	мРез.Вставить("Line",СтрЗаменить(str,Символы.ПС,"    "));
	Если ОтложенныйХеш=Ложь Тогда
		мРез.Вставить("_hash",ОбработкаИзмененийКонфигурацийВызовСервера.ПолучитьХеш(str));
	Иначе
		мРез.Вставить("_hash",str);
	КонецЕсли;
	
	Возврат мРез;
КонецФункции

&НаКлиенте
Функция CompareTo(_object,_compared,ОтложенныйХеш=Истина)
	мРез = 0;
	Если ОтложенныйХеш=Ложь Тогда
		Если строка(_object._hash)=строка(_compared._hash) Тогда
			мРез = 0;
		ИначеЕсли строка(_object._hash)>строка(_compared._hash) Тогда 
			мРез = -1;
		ИначеЕсли строка(_object._hash)<строка(_compared._hash) Тогда 
			мРез = 1;		
		КонецЕсли;
	Иначе
		Если _object._hash=_compared._hash Тогда
			мРез = 0;
		ИначеЕсли _object._hash>_compared._hash Тогда 
			мРез = -1;
		Иначе 
			мРез = 1;		
		КонецЕсли;
	КонецЕсли;
	// -1 до в порядке сортировки
	// 0 та же позиция
	// 1 находится после в порядке сортировки
	Возврат мРез;
КонецФункции

&НаКлиенте
Процедура _SetNoMatch(curItem)
	_startIndex = BAD_INDEX_Получить();
	curItem._length = DiffStatus_Получить("NoMatch");
	curItem.Status = DiffStatus_Получить("NoMatch");
КонецПроцедуры

&НаКлиенте
Процедура _SetMatch(start, length, curItem)
	curItem._startIndex = start;
	curItem._length = length;
	curItem.Status = DiffStatus_Получить("Matched");
	curItem.EndIndex = start+length;
КонецПроцедуры

&НаКлиенте
Функция _HasValidLength(newStart, newEnd, maxPossibleDestLength,curItem)
	
	Если (curItem._length > 0) Тогда //have unlocked match
		
		Если ((maxPossibleDestLength < curItem._length) ИЛИ
			((curItem._startIndex < newStart) ИЛИ (curItem.EndIndex > newEnd)))    Тогда 			
			SetToUnkown(curItem);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат (curItem._length <>DiffStatus_Получить("Unknown"));
	
КонецФункции

// Функция - Diff status получить
//
// Параметры:
//  str	 - строка - Unknown, Matched, NoMatch 
// 
// Возвращаемое значение:
//   - число
//
&НаКлиенте
Функция DiffStatus_Получить(str)
	Если str="Unknown" Тогда
		Возврат -2;
	ИначеЕсли str="Matched" Тогда
		Возврат 1;
	ИначеЕсли str="NoMatch" Тогда
		Возврат -1;
	КонецЕсли;	
КонецФункции

&НаКлиенте
Функция DiffResultSpanStatus_Получить(str)
	Если str="NoChange" Тогда
		Возврат 0;
	ИначеЕсли str="Replace" Тогда
		Возврат 1;
	ИначеЕсли str="DeleteSource" Тогда
		Возврат 2;
	ИначеЕсли str="AddDestination" Тогда
		Возврат 3;
	КонецЕсли;		
КонецФункции

&НаКлиенте
Процедура SetToUnkown(this)
	this._length = DiffStatus_Получить("Unknown");
	this._startIndex = BAD_INDEX_Получить();
КонецПроцедуры

&НаКлиенте
Функция BAD_INDEX_Получить()
	Возврат -1;
КонецФункции

&НаКлиенте
Функция _GetByIndex(destIndex, _stateList)
	
	Возврат _stateList[destIndex];
	
КонецФункции

&НаКлиенте
Функция _stateList_GetByIndex(destIndex,
	// поля структуры
	_stateList)
	
	мРез = _stateList[destIndex];
	
	// создадим дефолтную структуру
	Если мРез=Неопределено Тогда
		мРез = новый Структура("Status,_startIndex,EndIndex,_length","Unknown",-1,-4,-2);
		_stateList[destIndex] = мРез;
		мРез = _stateList[destIndex];
	КонецЕсли;
	
	Возврат мРез;
	
КонецФункции

&НаКлиенте
Функция DiffStateList(destCount)	
	_array = новый Массив(destCount);
	Возврат _array;
КонецФункции

&НаКлиенте
Функция ПолучитьСтруктуруDiffResultSpan()
	Возврат новый Структура("destIndex,sourceIndex,length,Status,_status");
КонецФункции

&НаКлиенте
Функция CreateNoChange(destIndex, sourceIndex, length)
	this =  ПолучитьСтруктуруDiffResultSpan();
	
	this.Status 		= DiffResultSpanStatus_Получить("NoChange");
	this._status 		= "NoChange";
	this.destIndex 		= destIndex;
	this.sourceIndex 	= sourceIndex;
	this.length 		= length;
	
	Возврат this;
КонецФункции

&НаКлиенте
Функция CreateReplace(destIndex, sourceIndex, length)
	this =  ПолучитьСтруктуруDiffResultSpan();
	
	this.Status 		= DiffResultSpanStatus_Получить("Replace");
	this._status 		= "Replace";
	this.destIndex 		= destIndex;
	this.sourceIndex 	= sourceIndex;
	this.length 		= length;
	
	Возврат this;
КонецФункции

&НаКлиенте
Функция CreateDeleteSource(sourceIndex, length)
	this =  ПолучитьСтруктуруDiffResultSpan();
	
	this.Status 		= DiffResultSpanStatus_Получить("DeleteSource");
	this._status 		= "DeleteSource";
	this.destIndex 		= BAD_INDEX_Получить();
	this.sourceIndex 	= sourceIndex;
	this.length 		= length;
	
	Возврат this;
КонецФункции

&НаКлиенте
Функция CreateAddDestination(destIndex,  length)
	this =  ПолучитьСтруктуруDiffResultSpan();
	
	this.Status 		= DiffResultSpanStatus_Получить("AddDestination");
	this._status 		= "AddDestination";
	this.destIndex 		= destIndex;
	this.sourceIndex 	= BAD_INDEX_Получить();
	this.length 		= length;
	
	Возврат this;
КонецФункции




#КонецОбласти



#КонецОбласти

