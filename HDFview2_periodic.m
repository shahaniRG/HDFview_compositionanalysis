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

c1 = zeros(180000,1);

counter = 1;
pp = zeros(80,1);
for k = 120691:1000:179691 %2000 %122001:180000
    fprintf('%d\n', k);

%    fprintf('%d\', k); % 98961 ~98, 99961 ~99, has a problem, 100961 ~100
%    flipped
    
    %Load data
    data = double(h5read('proj_0480.hdf', '/entry/data/data', [1 1 k], [2560 800 1]));
    data = imrotate(data, 270);
    kk = mod(k,2000);
    if kk ==0
       kk = 2000;
    end
    %Load liquid
    if k > 100000
        Liquid = double(h5read('proj_0480.hdf', '/entry/data/data', [1 1 kk+120000], [2560 800 1])); 
    else
        Liquid = double(h5read('proj_0480.hdf', '/entry/data/data', [1 1 kk], [2560 800 1])); 
    end
    Liquid = imrotate(Liquid, 270);  
    
    I1 = ((data)-(dark))./((white)-(dark)); % Data normarization
    I11 = data(210:450, 2371:end); 
    I11_BN = sum(data(:))/(241*190);
    
    I2 = ((Liquid)-(dark))./((white)-(dark)); % Liquid normalization
    I22 = Liquid(210:450, 2371:end);
    I22_BN = sum(Liquid(:))/(241*190);
    
    factor = I11_BN./I22_BN; %correction factor based on the sample holder,,
    
    I3 = (I1/factor-I2);
    %I4 = I3(50:400, 1110:1380);
    %window 655:738
    if kk < 1001
       I4 = I3(50:400, 1130:1230);
    else
       I4 = I3(50:400, 1360:1460);
    end
    sum(I4(:))/(351*101)
    pp(counter) = sum(I4(:))/(351*101);
    c1(counter) = sum(I4(:))/(351*101);
       
    counter = counter+1;
    
end

c_comp1 = (0.0849 - c1)./(0.0849 + 0.3630);
 
 m = zeros(180,1);
 for i = 1:180
     m(i) = sum(c_comp1(1+1000*(i-1):1000*i, 1))/1000;
 end
% 
% 
% c21 = zeros(58000,1); 
% c22 = zeros(58000,1);
% 
% counter = 1;
% 
% for k = 122001:180000 %122001:180000
%     fprintf('%d\n', k);
% 
%     data = double(h5read('proj_0480.hdf', '/entry/data/data', [1 1 k], [2560 800 1]));
%     data = imrotate(data, 270);
%     kk = mod(k,2000);
%     if kk ==0
%        kk = 2000;
%     end
%     %Load liquid
%     
%     Liquid = double(h5read('proj_0480.hdf', '/entry/data/data', [1 1 kk+120000], [2560 800 1])); 
%     Liquid = imrotate(Liquid, 270);  
%     
%     I1 = ((data)-(dark))./((white)-(dark)); % Data normarization
%     I11 = data(210:450, 2371:end); 
%     I11_BN = sum(data(:))/(241*190);
%     
%     I2 = ((Liquid)-(dark))./((white)-(dark)); % Liquid normalization
%     I22 = Liquid(210:450, 2371:end);
%     I22_BN = sum(Liquid(:))/(241*190);
%     
%     factor = I11_BN./I22_BN;
%     
%     I3 = (I1/factor-I2);
%    
%     I41 = I3(550:710, 1130:1230); %even
%     I42 = I3(550:710, 1360:1460); %odd
%     
%     c21(counter) = sum(I41(:))/(161*101);
%     c22(counter) = sum(I42(:))/(161*101);
%     
%     counter = counter+1;
% 
% end
% 
% c_comp21 = (0.0849 - c21)./(0.0849 + 0.3630); % 0.0849: Al signal, -0.3630: heavy elements
% c_comp22 = (0.0849 - c22)./(0.0849 + 0.3630);
% 
% % m2 = zeros(58,1);
% % for i = 1:58
% %     m2(i) = sum(c_comp21(1000*(i-1)+655:1000*(i-1)+738, 1))/84;
% % end
% % m3 = zeros(58,1);
% % for i = 1:58
% %     m3(i) = sum(c_comp22(1000*(i-1)+655:1000*(i-1)+738, 1))/84;
% % end


