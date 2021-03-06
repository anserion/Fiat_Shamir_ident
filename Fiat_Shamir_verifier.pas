//Copyright 2017 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

//учебный шаблон сервера идентификации с нулевым разглашением (проверяющий)
//по протоколу Фиата-Шамира

//Общая постановка задачи.
//Доказывающая сторона владеет секретом S (число)
//Проверяющая сторона должна убедиться в наличии S у доказывающей стороны в
//условиях отсутствия доступа непосредственно к S.
//Проверяющая сторона не имеет возможности доказать третьей стороне наличие S
//у доказывающей стороны

// протокол идентификации с нулевым разглашением Фиата-Шамира
// 1. Центр распределения ключей генерирует два простых числа p,q
//    которые сообщаются доказывающей стороне (секретно)
//    и их произведение n=p*q (публично).
//    (в данной программе p и q не генерируются, n полагается известным всем)
//    доп. условие, повышающее качество алгоритма: p,q сравнимы с 3 по модулю 4 
//    криптостойкость алгоритма основана на сложности операции
//    извлечения корня квадратного в конечных полях
// 2. Доказывающая сторона генерирует и оглашает публичное свойство секрета:
//    V=(S*S) mod n
// 3. Доказывающая сторона генерирует произвольное (случайное) число R,
//    пригодное для дальнейшей работы алгоритма 0<r<n.
// 4. Доказывающая сторона публикует значение X=(R*R) mod n.
// 5. Проверяющая сторона генерирует и публикует случайный бит E.
// 6. Если E=0, то доказывающая сторона публикует значение Y=R,
//    если E=1, то доказывающая сторона публикует значение Y=(R*S) mod n.
// 7. Если E=0, то проверяющая сторона сравнивает X и (Y*Y) mod n на равенство
//    Если E=1, то проверяющая сторона сравнивает (X*V) mod n и (Y*Y) mod n на равенство
// 8. В случае неравенства протокол прекращает работу (срыв доказательства)
// 9. Шаги 3-8 повторяются t раз (достаточно 20-40 раз) для убеждения проверяющего.
//    Вероятность обмана проверяющего при этом равна 2^(-t), т.е. очень мала.

program fiat_shamir_verifier;
var
   n:integer; //публичный модуль вычислений
   e:integer; //секретный выбор проверяющего
   V:integer; //публичное свойство секрета
   x,y:integer; //рабочие переменные протокола
   flag:boolean;
begin
   //ввод исходных данных
   writeln('Zero-knowledge proof Fiat-Shamir identity protocol (verifier side)');
   writeln('n - public modulo (number)');
   writeln('V - public property of the secret (number)');
   writeln('X - public question from prover (number)');
   writeln('E - request bit to prover (number 0 or 1)');
   writeln('Y - public answer from prover (number)');
   //ввод публичного модуля
   write('n='); readln(n);
   //ввод публичного свойства секрета
   write('waiting from the prover: V='); readln(v);
   
   flag:=false; randomize;
   repeat
      //ожидание ввода запроса на проверку от доказывающей стороны
      writeln;
      write('waiting from the prover: X='); readln(X);
      //шаг 5. генерация и публикация случайного бита E выбора способа проверки
      E:=random(2);
      writeln('to the prover: E=',E);
      //ожидание ответа от доказывающей стороны
      write('waiting from the prover (0 - exit): Y='); readln(Y);
      //шаг 7. проверка ответа
      if E=0 then flag:=(X=((Y*Y)mod n));
      if E=1 then flag:=((X*V)mod n)=((Y*Y)mod n);
      if flag then writeln('OK') else writeln('ERROR');
   until flag=false;
end.
