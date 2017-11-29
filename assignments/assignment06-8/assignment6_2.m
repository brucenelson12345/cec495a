% assignemnt 6 v2

% lecture06

clear all; close all; clc;

img = 'xcorr/480096.jpg';
slashInd = strfind(img, '/');
typeInd = strfind(img, '.');
actualPostcode = str2double(img(slashInd(end)+1:typeInd(end)-1));
%disp(actualPostcode);
actualPostcode = num2str(actualPostcode)-'0';

imgTemplate = imread('xcorr/training.jpg');
imgUnknown  = imread(img);

postcodeList = [];

for runs = 1:5
    
    mynet = annTrain(imgTemplate);
    UPattern = annUnknown(imgUnknown);

    Y = sim(mynet,UPattern);

    [values, postcodes] = max(Y);

    % offsets the position to generate complete post code
    postcode = postcodes-1;
    %disp('postcode = ');
    %disp(postcode);
    
    postcodeList(end+1,:) = postcode;
end

[row, col] = size(postcodeList);

totalDigits = row * col;
incorrectDigits = 0;

for k = 1:row
    result = actualPostcode == postcodeList(k,:);
    %(result);
    incorrectDigits = incorrectDigits + sum(~result);
end

correctDigits = totalDigits - incorrectDigits;
percentCorrect = (correctDigits/totalDigits) * 100;

disp("Unknown Image: ");
disp(actualPostcode);
disp("Total Runs: ");
disp(runs);
disp("Correct Digits: ");
disp(correctDigits);
disp("Incorrect Digits: ");
disp(incorrectDigits);
disp("Correct %: ");
disp(percentCorrect);
