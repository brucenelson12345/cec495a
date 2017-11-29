% Assignment 5
% Bruce Nelson

unknownImage = imread('xcorr/unknown.jpg');
templateImage = imread('xcorr/template.jpg');

[UnknownImage, UnknownImageScaled] = imageScaled(unknownImage);
[TemplateImage, TemplateImageScaled] = imageScaled(templateImage);

[rowU, colU] = size(UnknownImage);
[rowT, colT] = size(TemplateImage);

postCorr = [];
postcodes = [];

for j = 1:colU
    maxCorr = [];
    for k = 1:colT
        corr = normxcorr2(UnknownImageScaled{j},TemplateImageScaled{k});
        maxCorr(end+1) = max(corr(:));
    end
    [postCorr(end+1),postcodes(end+1)] = max(maxCorr(:));
end

% offsets the position to generate complete post code
postcode = postcodes-1;
disp('postcode = ');
disp(postcode);




