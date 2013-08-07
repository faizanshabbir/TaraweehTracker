%constants
numDays = 30;
hallMax = 414;  %1st = 28, 2nd = 36, 3rd-10th = 50
                %Safs outside of hall 10th-20th = 30

%Open file
fileID = fopen('data\Taraweeh Tracker - Abdasis.csv');

%Read CSV file into a matrix
dataMat = textscan(fileID, '%f %s %f %s %f %s %f %s %f %s %f %s %f %s %f %s %f %s %s', 'delimiter', ',', 'EmptyValue', 0);

xOdd = 1:2:length(dataMat);
xEven = 2:2:length(dataMat);

Rakahs = dataMat(1,xOdd);
Juzz = dataMat(1,end);
Rakahs = Rakahs(:,1:end-1);
Rakahs = cat(2,Rakahs{:});
Times = dataMat(1,xEven);
Times = cat(2,Times{:});

origRakahs = Rakahs;

%Interpolate by columns
%Only works for first column.  Fix.  Separate columns and then join?
for i = 1:size(Rakahs,2)
    idxToFill = find(Rakahs(:,i)<1);
    [xToFill colF] = find(Rakahs(:,i)<1);
    idxFilled = find(Rakahs(:,i)>1);
    [xFilled colF] = find(Rakahs(:,i)>1);  
    y = Rakahs(idxFilled);
    Rakahs(idxToFill,i) = interp1(xFilled,y,xToFill);
end

cutoff = floor(Rakahs);
Safs = Rakahs - cutoff;

upperIdx = find(Rakahs>10);
lowerIdx = find(Rakahs<10);
others = find(ismember(Rakahs,10));

upper = Rakahs(upperIdx);
lower = Rakahs(lowerIdx);

upMod = mod(upper,10);
loMod = mod(lower,10);

loMod = loMod - 2;

numPeopleLo = loMod*50+64;
numPeopleUp = upMod*30+hallMax;

finCountPeople = zeros(size(Rakahs));
finCountPeople(upperIdx) = numPeopleUp;
finCountPeople(lowerIdx) = numPeopleLo;
finCountPeople(others) = hallMax;

% idx = find(Safs>2 & Safs<11);
% midSafs = ismember(Safs,idx);
% midSafs = midSafs - 2;
% midSafs = midSafs * 50 + 64; %Check validatity fo adding 64
% 
% secSafs = find(Safs==2);
% secSafs = secSafs.*64;
% 
% firstSafs = find(Safs==1);
% firstSafs = firstSafs.*28;
% 
% finalSafcount = midSafs.*lowSafs;
% 
% conversion = (1*28+1*36+8*50)/10;