clear;
pkg load signal;

list_bad = glob('guitar_bad/**/*.wav');
list_ok = glob('guitar_ok/*.wav');
choice = menu('choose type of note', 'ok', 'bad');

if choice==1
  choice = menu('choose note', list_ok);
  datoteka = list_ok{choice};
elseif choice==2
  choice = menu('choose note', list_bad);
  datoteka = list_bad{choice};
endif
%datoteka = 'guitar_ok/8402__speedy__clean-g-str-pick.wav';
[x, fs] = audioread(datoteka);
info = audioinfo(datoteka);
% dolzina signala x
L = length(x);
% Fourierjeva transformacija signala x
Y = fft(x);
% Izraèunam zrcalni spekter
P2 = abs(Y/L);
% Iz spektra P1 vzamem vrednosti do polovice, da se mi ne podvajajo zrcalno
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
% izraèunam domeno frekvence tako da pomnožim frekvenco vzorèenja z vektorjem,
% ki gre do polovice dolžine signala ter jih delim z dolžino signala
f = fs*(0:(L/2))/L;
plot(f,P1);
% sortiram vrednosti iz P1 tako da dobim vrhove(peaks)
[sorted, indices] = sort(P1);
indexes = f(indices);
% vzamem najveèjih 26 vrhove
indexes = indexes(end-25:end);
values = sorted(end-25:end);
% od teh vrhov vzamem samo tiste ki so veèji od njihovega povpreèja
M = mean(values);
M1 = values(values>M);
M2 = [];
i = 0;
% poišèem frekvence po vrhovih in za izbrano frekvenco vzamem
% najbolj levo, torej najmanjšo frekvenco
while (i < length(M1))
  ind = M1(end-i);
  result = find(values == ind);
  M2 = [M2 ; indexes(result)];
  i++;
endwhile
frekvenca = min(M2);
frekvence = [329.63, 246.94, 196.00, 146.83, 110.00, 82.41];
note = {"E4"; "B3"; "G3"; "D3"; "A2"; "E2"};
[minDistance, indexOfMin] = min(abs(frekvence-frekvenca));
nota = note{indexOfMin};
printf("Zaigrana nota: %s\n", nota);
if (frekvenca < frekvence(indexOfMin)-1)
  printf("Tune your string higher!\nExpected frequency: %dHz\n", frekvence(indexOfMin));
  printf("Measured frequency: %dHz\n", frekvenca);
elseif (frekvenca > frekvence(indexOfMin)+1)
  printf("Tune your string lower!\nExpected frequency: %dHz\n", frekvence(indexOfMin));
  printf("Measured frequency: %dHz\n", frekvenca);
else
  printf("Perfect tuning!\n");
  printf("Measured frequency: %dHz\n", frekvenca);
endif