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

%Separate raw data matrix into appropriate data vectors for statistics
Juzz = dataMat(1,end);
Rakahs = dataMat(1,xOdd);
Rakahs = Rakahs(:,1:end-1);
Rakahs = cat(2,Rakahs{:});
Times = dataMat(1,xEven);
Times = cat(2,Times{:});
origRakahs = Rakahs;

%Interpolate empty data by columns
for i = 1:size(Rakahs,2)
    idxToFill = find(Rakahs(:,i)<1);
    [xToFill colF] = find(Rakahs(:,i)<1);
    idxFilled = find(Rakahs(:,i)>1);
    [xFilled colF] = find(Rakahs(:,i)>1);  
    y = Rakahs(idxFilled);
    Rakahs(idxToFill,i) = interp1(xFilled,y,xToFill);
end

%Convert number of safs to number of people
cutoff = floor(Rakahs);
cutoff = Rakahs - cutoff;

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
cutoff(upperIdx)=cutoff(upperIdx)*30;
cutoff(lowerIdx)=cutoff(lowerIdx)*50;

finCountPeople = zeros(size(Rakahs));
finCountPeople(upperIdx) = numPeopleUp;
finCountPeople(lowerIdx) = numPeopleLo;
finCountPeople(others) = hallMax;
finCountPeople = finCountPeople + cutoff;
