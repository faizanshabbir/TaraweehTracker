%constants
numDays = 30;

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

%Interpolate by columns
for i = 1:size(Rakahs,2)
    idxToFill = find(Rakahs(:,i)<1);
    [xToFill colF] = find(Rakahs(:,i)<1);
    idxFilled = find(Rakahs(:,i)>1);
    [xFilled colF] = find(Rakahs(:,i)>1);  
    y = Rakahs(idxFilled);
    Rakahs(idxToFill) = interp1(xFilled,y,xToFill);
end

cutoff = floor(Rakahs);
Safs = Rakahs - cutoff;



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