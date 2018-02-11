% h5disp('proj_0480.hdf');
% 
% info = h5info('proj_0480.hdf');

    white = 0; dark = 0;
    %Load dark & white images
    for i = 1:10    
        white1 = double(h5read('proj_0504.hdf', '/entry/data/data', [1 1 i], [2560 800 1]));
        white1 = imrotate(white1, 270);
        white = white1 + white;
    
        dark1 = double(h5read('proj_0505.hdf', '/entry/data/data', [1 1 i], [2560 800 1]));
        dark1 = imrotate(dark1, 270);
        dark = dark1 +dark;
    end
    white = white/10; dark = dark/10;
%     white = imrotate(white, 270); 
%     dark = imrotate(dark, 270); 

c = zeros(120000,1);
counter = 1;
p = zeros(124,1);
for k = 961:1000:123961 %k = 961:1000:123961 %
    fprintf('%d\n', k);

%    fprintf('%d\', k); % 98961 ~98, 99961 ~99, has a problem, 100961 ~100
%    flipped
    % Liquid < 100 odd number --> 35001, even number --> 36001, 
    % Liquid >=100 even number --> 126001, odd number --> 125001
    %Load data
    data = double(h5read('proj_0480.hdf', '/entry/data/data', [1 1 k], [2560 800 1]));
    data = imrotate(data, 270);
    kk = mod(k,2000);
    if kk ==0
       kk = 2000;
    end
    %Load liquid
    Liquid = double(h5read('proj_0480.hdf', '/entry/data/data', [1 1 kk], [2560 800 1]));  
    Liquid = imrotate(Liquid, 270);  
    
    % normalize, (data- black)/(white -black) -Liquid
    % and scale with respect to two reference points
     I1 = ((data)-(dark))./((white)-(dark));
     I11 = data(210:450, 2371:end);
     %I1 = (I1 - min(I11(:)))./(max(I11(:)) - min(I11(:)));
     I11_BN = sum(data(:))/(241*190);
     
     % I1 = (I1 - min(I11(:))./(max(I11(:)) - min(I11(:))));
     
     I2 = ((Liquid)-(dark))./((white)-(dark));
     I22 = Liquid(210:450, 2371:end);
     %I2 = (I2 - min(I22(:)))./(max(I22(:)) - min(I22(:)));
     I22_BN = sum(Liquid(:))/(241*190);
     
     factor = I11_BN./I22_BN;
     
     % I22 = I2(210:450, 2371:end);
     % I2 = (I2 - min(I22(:))./(max(I22(:)) - min(I22(:))));
     %I111 = I1/factor;
     %I3 = (I1/factor-I2);
     I3 = (I1/factor-I2);

     I4 = I3(50:400, 1110:1380);%for liquid (50:400, 1110:1380), for QC(610:670, 1260:1330)
%     I4 = I3(610:670, 1260:1330);    
%      pp(counter) = sum(I4(:))/(351*271);
     c(counter) = sum(I4(:))/(351*271);
     p(counter) = sum(I4(:))/(351*271);
%     c(counter) = sum(I4(:))/(61*71);
     counter = counter+1;

end
%syms x y %use this one
%[solx,soly] = solve(0.818121*x +0.181879*y == 0.0034, 0.7*x+0.3*y== -0.0495)
c5555 = (0.0849 - c)./(0.0849 + 0.3630); %from the first one.

%save as .txt
%  fid=fopen('data.txt','wt');
% fprintf(fid,'%d\n',c4);
% fclose(fid);





%syms x y
%[solx,soly] = solve(0.81752*x +0.18248*y == 0.1237, 0.7*x+0.3*y== -0.8639)
%c6 = (0.123-c)./(0.123+0.5229); 

%c4 = (1.6572-c)./(1.6572+6.7465);
% c4 is calculated from 76961, 961 was used for normalization..
% from the equation, x = 0.123, y = -0.5229
%syms x y
%[solx,soly] = solve(0.81752*x +0.18248*y == 0.0051, 0.7*x+0.3*y== -0.0708)
% syms x y z
% [solx,soly,solz] = solve(0.818121*x + 0.0909395*y + 0.0909395*z == 0.0034, 0.7*x+0.15*y +0.15*z == -0.0495, 0.83437*x + 0.130505*y + 0.035125*z == -0.0082)