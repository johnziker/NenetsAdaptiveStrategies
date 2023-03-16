  
% >>>>>>>>>>>>> To get all station data, do this first: <<<<<<<<<<<<<<<<<
% AllSrfIce = []; AllIceRn = []; AllWetSnw = [];

pt = '/Users/ivanov/_HYDRO_PAPER/_PAPERS_SUBMITTED/_ARCTIC/Reindeer_Climate_PTrans_2023/_DATA/Atmospheric_phenomena_Yamal_1965_2021';
path(path, pt);

% ---- BEFORE ARRAY FILLING BELOW:  AllSrfIce=[]; AllIceRn=[]; AllWetSnw=[];


if (0)

sitename = '20667'; stationname = 'Named after M.V. Popov';
sitename = '23032'; stationname = 'Marre Sale';
sitename = '23330'; stationname = 'Salekhard';
sitename = '23242'; stationname = 'Novyi Port';
sitename = '23345'; stationname = 'Nyda';
xPer = 1966:2021; % <- the entire period

if (1)
    filename = [sitename '.txt'];
    fid = fopen(filename, 'r');
    if (fid < 0 )
        disp(sprintf(['\nERROR: File ', filepath, ' cannot be open! Re-check the set paths and current folder. Exiting...\n']))
        return;
    end

    Datinp=textscan(fid,'%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%s%s','headerlines',0,'TreatAsEmpty','"NAN"');
    fclose(fid);

    fid = -999;
end

% time stamp
% for i = 1:size(A,1)
%     TS(i) = datetime(A{i}(2:end-1),'InputFormat', 'yyyy-MM-dd HH:mm:ss');
% end


% Convert the time tags to Matlab serial date numbers 
TtagMLoc = datenum(double([Datinp{6}]), double([Datinp{7}]), double([Datinp{8}]));


% To set in local time
HHOffset = 0; 

% ******************************************************************
% This will create array of *local* time (shifted back by 4 hours)
TtagM = TtagMLoc - HHOffset/24; TtagMArr = TtagM; % <-- Just to save a copy
TtagM = datetime(datevec(TtagM)); 
% ******************************************************************

% Index of the atmospheric phenomenon 
% (described in Atmospheric_phenomena_Yamal_KEY.xlsx)
iAtmPhen = [Datinp{15}];

% Surface icing
i12 = find(iAtmPhen == 12);
i18 = find(iAtmPhen == 18);
i1218 = find((iAtmPhen == 12) | (iAtmPhen == 18));

idays12 = unique(TtagMLoc(i12));
idays18 = unique(TtagMLoc(i18));
[idays1218, ia1218, ic1218] = unique(TtagMLoc(i1218));

% Icy rain
i51 = find(iAtmPhen == 51);
[idays51, ia51, ic51] = unique(TtagMLoc(i51));

% Wet snowfall
i72 = find(iAtmPhen == 72);
i73 = find(iAtmPhen == 73);
i7273 = find((iAtmPhen == 72) | (iAtmPhen == 73));
idays72 = unique(TtagMLoc(i72));
idays73 = unique(TtagMLoc(i73));
[idays7273, ia7273, ic7273] = unique(TtagMLoc(i7273));


% ///////////////////////////////////////////////////////////////////////////
% "Summer" months: How we define SUMMER vs. WINTER
ismms = 6; ismme = 9; 
% ###########################################################################


% Convert Matlab unique days into date strings
% Surface icing
% *SPECIFIC DATES* when the event took place
Dates1218 = datevec(TtagMLoc(i1218(ia1218))); DaysEvent1218All =[];
[iyyrs1218, iayy1218, icyy1218] = unique(Dates1218(:,1)); % <-- unique years
for ii=1:length(iyyrs1218)
    iiyear = find(icyy1218 == ii);
    iiyearwin = find(Dates1218(iiyear,2) < ismms | Dates1218(iiyear,2) > ismme);
    nPhnWnt = length(iiyearwin); if (~nPhnWnt) nPhnWnt = 0; end % changed to 0 from Nan
    DaysEvent1218All = [DaysEvent1218All; iyyrs1218(ii) length(iiyear) nPhnWnt];
end

% Icy rain
% *SPECIFIC DATES* when the event took place
Dates51   = datevec(TtagMLoc(i51(ia51)));  DaysEvent51All = [];
[iyyrs51, iayy51, icyy51] = unique(Dates51(:,1));  % <-- unique years
for ii=1:length(iyyrs51)
    iiyear = find(icyy51 == ii);
    iiyearwin = find(Dates51(iiyear,2) < ismms | Dates51(iiyear,2) > ismme);
    nPhnWnt = length(iiyearwin); if (~nPhnWnt) nPhnWnt = 0; end
    DaysEvent51All = [DaysEvent51All; iyyrs51(ii) length(iiyear) nPhnWnt];
end

% Wet snowfall
% *SPECIFIC DATES* when the event took place
Dates7273 = datevec(TtagMLoc(i7273(ia7273)));  DaysEvent7273All = [];
[iyyrs7273, iayy7273 icyy7273] = unique(Dates7273(:,1));  % <-- unique years
for ii=1:length(iyyrs7273)
    iiyear = find(icyy7273 == ii);
    iiyearwin = find(Dates7273(iiyear,2) < ismms | Dates7273(iiyear,2) > ismme);
    nPhnWnt = length(iiyearwin); if (~nPhnWnt) nPhnWnt = 0; end
    DaysEvent7273All = [DaysEvent7273All; iyyrs7273(ii) length(iiyear) nPhnWnt];
end

% --------------->>>>> Find years that have NOT been observed in the period
[unyyall, iayy, icyy] = unique([DaysEvent1218All(:,1); DaysEvent51All(:,1);  DaysEvent7273All(:,1)]);
yyNotObs = setdiff(xPer, unyyall);

% HOWEVER, this does NOT include an analysis of how many months of data 
% are present in a given year: some have 12, some have 1-2 months only 
% (and thus their count of atm. phenomena may not be sufficient)

% //////////////////////////////////////////////////////////////////////
figure('Position',[78    57   918   800])
for ipp = 1:6
    if     (ipp == 1 | ipp == 2) xd = DaysEvent1218All(:,1); maxyr = max(xd); fc = [160 160 160]; ec = [102 102 255]; end
    if     (ipp == 1) yd = DaysEvent1218All(:,2); titlestr = ['Surface icing - All months, station: ', stationname];
    elseif (ipp == 2) yd = DaysEvent1218All(:,3); titlestr = ['Surface icing - Fall-Winter-Spring, station: ', stationname]; end;

    if     (ipp == 3 | ipp == 4) xd = DaysEvent51All(:,1); maxyr = max(xd); fc = [51 51 255]; ec = [204 204 255]; end
    if     (ipp == 3) yd = DaysEvent51All(:,2); titlestr = 'Icy rain - All months';
    elseif (ipp == 4) yd = DaysEvent51All(:,3); titlestr = 'Icy rain - Fall-Winter-Spring'; end;

    if     (ipp == 5 | ipp == 6) xd = DaysEvent7273All(:,1); maxyr = max(xd); fc = [153 153 255]; ec = [0 0 204]; end
    if     (ipp == 5) yd = DaysEvent7273All(:,2); titlestr = 'Wet snowfall - All months';
    elseif (ipp == 6) yd = DaysEvent7273All(:,3); titlestr = 'Wet snowfall - Fall-Winter-Spring'; end;

    % Some of the years are not present in the estimates: 
    %  it could be because the station did not observe these phenomena or 
    %  becuase it was closed/not working 
    % -> I will assign data records to zero first 
    %    (i.e., assume phenomena were not observed)
    % -> and if the year is indeed entirely missin in all of the records 
    %    (i.e., the year is in 'yyNotObs' array), assign NaN

    ydAdj = [];
    for i=1:length(xPer)
        iyy = find(xd == xPer(i));
        if (isempty(iyy))
            ydAdj(i) = 0;
            if (~isempty(find(yyNotObs == xPer(i))))
                ydAdj(i) = NaN; end
        else
            ydAdj(i) = yd(iyy);
        end
    end

    % Storing all values in arrays
    if (1)
        if (ipp == 2)      AllSrfIce = [AllSrfIce; ydAdj];
        elseif (ipp == 4)  AllIceRn  = [AllIceRn; ydAdj];
        elseif (ipp == 6)  AllWetSnw = [AllWetSnw; ydAdj]; end
    end

    % Fit a linear model
    % mdl = fitlm(xd(end-29:end),yd(end-29:end)); 

    % medyd = median(yd(24:end));
    medyd = median(yd(1:end));


    subplot(3,2,ipp); 
    % plot(xd, yd, 'o','MarkerFaceColor', fc./255,'MarkerEdgeColor', ec./255, 'MarkerSize',8); grid on; hold on
    plot(xPer, ydAdj, 'o','MarkerFaceColor', fc./255,'MarkerEdgeColor', ec./255, 'MarkerSize',8); grid on; hold on
    plot([min(xd) max(xd)], [medyd medyd], 'k', 'LineWidth', 0.4, 'LineStyle','--')
    ylabel('# of days'); title(titlestr, 'FontWeight','bold','FontSize', 13);
    %xlim([1990 2021])
    xlim([1966 2021])
    ylim([0 45])
    set(gca,'fontsize', 14);
    set(gcf,'color','w')

    if  (ipp < 3 | ipp > 4)
        % Smooth the data using the loess and rloess methods:
        %        moving average with a span of SMSPAN*100%
        SMSPAN = 0.5;
        yy1 = smooth(xd,yd,SMSPAN,'loess');
        yy2 = smooth(xd,yd,SMSPAN,'rloess');
        plot(xd,yy1,'color', ec./255, 'LineWidth', 2.0, 'LineStyle','-.')
        %plot(xd,yy2,'color', ec./255, 'LineWidth', 2.0, 'LineStyle','-.')

        %[xx,ind] = sort(xd);
        %plot(xx,yy2(ind),'r-')
    end

    if (ipp == 2 | ipp == 4 | ipp == 6)
        if (ipp == 2)   evType = 'surf_ice';
        elseif (ipp==4) evType = 'icy_rain';
        elseif (ipp==6) evType = 'wet snow'; end
        % xlswrite(['./Station',sitename,'_',stationname,'_',evType,'.xls'], [xd yd], 1, 'A1')

        % Write this -->>
        %xlswrite(['./Station',sitename,'_',stationname,'_',evType,'_strt1966.xls'], [xd yd], 1, 'A1')
    end
end
%orient tall
%print(gcf, '-djpeg90', '-r400',  ['./Station',sitename,'_',stationname,'_strt1966.jpg'])


% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% save('AllAtmPhenomena.mat', 'AllSrfIce', 'AllIceRn', 'AllWetSnw', 'xPer');


end




%% Combining all of the series together
if (0)

   load AllAtmPhenomena.mat

   load Аtm_1966_2021_temp_nohead.txt 
   AllTempSrf = X_tm_1966_2021_temp_nohead(:, 2:end);
   AllTempSrf(end,:) = NaN; AllTempSrf(find(AllTempSrf(:,1) < 0), 1) = NaN; 
   AllTempSrf= AllTempSrf'; 


   % Adjust arrrays for plotting:
   [xx, yy] = meshgrid(xPer,[1:5]);
   xPerC = reshape(xx, 5*56, 1);

   AllSrfIceC = reshape(AllSrfIce, 5*56, 1);
   AllIceRnC  = reshape(AllIceRn,  5*56, 1);
   AllWetSnwC = reshape(AllWetSnw, 5*56, 1);
   AllTempSrfC = reshape(AllTempSrf, 5*56, 1);

   % To control the degree of smoothness
   SMSPAN = 0.5;

   MedSrfIce = nanmedian(AllSrfIce);
   MedIceRn  = nanmedian(AllIceRn);
   MedWetSnw = nanmedian(AllWetSnw);
   MedTempSurf = nanmedian(AllTempSrf);

   yy1 = smooth(xPer, MedSrfIce, SMSPAN,'loess');
   yy2 = smooth(xPer, MedIceRn,  SMSPAN,'loess');
   yy3 = smooth(xPer, MedWetSnw, SMSPAN,'loess');
   yy4 = smooth(xPer, MedTempSurf, SMSPAN,'loess');

   Q2575SrfIce = quantile(AllWetSnw, [0.25 0.75]);
   Q2575IceRn  = quantile(AllIceRn,  [0.25 0.75]);
   Q2575WetSnw = quantile(AllWetSnw, [0.25 0.75]);
   Q2575TempSurf = quantile(AllTempSrf, [0.25 0.75]);


   figure
   subplot(4,1,1); fc = [160 160 160]; ec = [102 102 255];
   bc1 = boxchart(xPerC, AllSrfIceC, 'BoxFaceColor', fc./255'); hold on
   %plot(xPer, MedSrfIce, ':','color', ec./255)
   plot(xPer,yy1,'color', ec./255, 'LineWidth', 1.5, 'LineStyle','-.')

   titlestr = ['(a) Surface icing (October-May)'];
   ylabel('# of days'); title(titlestr, 'FontWeight','bold','FontSize', 13);
   xlim([1965 2022]); set(gca,'fontsize', 13);



   subplot(4,1,2); fc = [51 51 255];   ec = [204 204 255]; 
   bc2 = boxchart(xPerC, AllIceRnC, 'BoxFaceColor', fc./255'); hold on
   %plot(xPer,yy2,'color', ec./255, 'LineWidth', 1.5, 'LineStyle','-.')

   titlestr = '(b) Icy rain (October-May)';
   ylabel('# of days'); title(titlestr, 'FontWeight','bold','FontSize', 13);
   xlim([1965 2022]); set(gca,'fontsize', 13);



   subplot(4,1,3); fc = [153 153 255]; ec = [0 0 204]; 
   bc3 = boxchart(xPerC, AllWetSnwC, 'BoxFaceColor', fc./255'); hold on
   plot(xPer,yy3,'color', ec./255, 'LineWidth', 1.5, 'LineStyle','-.')

   titlestr = '(c) Wet snowfall (October-May)';
   ylabel('# of days'); title(titlestr, 'FontWeight','bold','FontSize', 13);
   xlim([1965 2022]); set(gca,'fontsize', 13);



   subplot(4,1,4); fc = [255,127,80]; ec = [220 20 60]; 
   bc3 = boxchart(xPerC, AllTempSrfC, 'BoxFaceColor', fc./255'); hold on
   plot(xPer,yy4,'color', ec./255, 'LineWidth', 1.5, 'LineStyle','-.')

   titlestr = '(d) Extreme heat (June-September)';
   ylabel('# of days'); title(titlestr, 'FontWeight','bold','FontSize', 13);
   xlim([1965 2022]); set(gca,'fontsize', 13);



   set(gcf,'color','w')

   % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   % Call trend analysis function
   % +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

   % ######################################
   % WHEN TREND ANALYSIS IS DONE ON MEDIANS
   if (0)
   datain = [xPer' MedSrfIce'];
   datain = [xPer' MedWetSnw'];
   datain = [xPer' MedTempSurf'];

   alp = 0.05;
   wantplot = 1;

   figure
   [taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3 nsigma] ...
       = ktaub(datain, alp, wantplot);
   end 
end




%% STATION LEVEL PLOTS AND ANALYSIS

if (1)
   
path(path,'/Users/ivanov/_HYDRO_PAPER/_PAPERS_SUBMITTED/_ARCTIC/Reindeer_Climate_PTrans_2023/_DATA/Atmospheric_phenomena_Yamal_1965_2021/ktaub');


   % ##################################################
   % WHEN TREND ANALYSIS IS DONE ON INDIVIDUAL STATIONS


   % This is a map of how locations are stored in All* arrays
   % assuming that we need to traverse from North to South:
   % (a) Belyi -> (b) M. Salle -> (c) N. Port -> (d) Nyda - (e) Salekhard
   iNtoS = [1 2 4 5 3];

   % Period common to all: 1966 - 2021
   xd = xPer; 

   figure;  set(gcf,'color','w')

   for ii=1:5
       for jj=1:4

           numSplot = (ii-1)*4+jj; 
           subplot(5, 4, numSplot); 


           if     (jj == 1) fc = [160 160 160]; ec = [102 102 255];
               if (ii==1) titlestr = ['(1) Surface icing']; else titlestr = ['(',num2str(numSplot),')']; end

           elseif (jj == 2) fc = [51 51 255];   ec = [204 204 255]; 
               if (ii==1) titlestr = ['(2) Icy rain']; else titlestr = ['(',num2str(numSplot),')']; end

           elseif (jj == 3) fc = [153 153 255]; ec = [0 0 204];
               if (ii==1) titlestr = ['(3) Wet snowfall']; else titlestr = ['(',num2str(numSplot),')']; end

           elseif (jj == 4) fc = [255,127,80]; ec = [220 20 60]; 
               if (ii==1) titlestr = ['(4) Extreme heat']; else titlestr = ['(',num2str(numSplot),')']; end; 
           end
           

           % Assign the series 
           if     (jj == 1) yd = AllSrfIce(iNtoS(ii), :);
           elseif (jj == 2) yd = AllIceRn(iNtoS(ii), :);
           elseif (jj == 3) yd = AllWetSnw(iNtoS(ii), :);
           elseif (jj == 4) yd = AllTempSrf(ii, :); end


           if     (ii==1) stationname = '\bfBelyi';
           elseif (ii==2) stationname = '\bfMarre Sale';
           elseif (ii==3) stationname = '\bfNovyi Port';
           elseif (ii==4) stationname = '\bfNyda';
           elseif (ii==5) stationname = '\bfSalekhard'; end

           medyd = nanmedian(yd(1:end));

           % Plot the series
           plot(xd, yd, 'o','MarkerFaceColor', fc./255,'MarkerEdgeColor', ec./255, 'MarkerSize',5); grid on; hold on
           plot([min(xd) max(xd)], [medyd medyd], 'k', 'LineWidth', 0.4, 'LineStyle','--')
           title(titlestr, 'FontWeight','bold','FontSize', 12);
           if (jj==1) ylabel([stationname,"# of days"]); end
           xlim([1965 2022]); set(gca,'fontsize', 13);

           if (jj==1 | jj==5 | jj==9  | jj==13 | jj==17) ylim([0 23]); end
           if (jj==2 | jj==6 | jj==10 | jj==14 | jj==18) ylim([0 10]); end
           if (jj==3 | jj==7 | jj==11 | jj==15 | jj==19) ylim([0 40]); end
           if (jj==4 | jj==8 | jj==12 | jj==16 | jj==20) ylim([0 60]); end

           if  (jj == 1 | jj > 2)
               % Smooth the data using the loess and rloess methods:
               %        moving average with a span of SMSPAN*100%
               SMSPAN = 0.5;
               yy1 = smooth(xd,yd,SMSPAN,'loess');
               plot(xd,yy1,'color', ec./255, 'LineWidth', 2.0, 'LineStyle','-.')
           end


           datain = [xd' yd'];

           alp = 0.05;
           wantplot = 0;
           [taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3 nsigma] ...
               = ktaub(datain, alp, wantplot);

           disp(sprintf(['\n-> PLOT # ',num2str(numSplot)]));

           if (h)
               disp(sprintf(['--> Trend IS significant at ',num2str(alp),' significance level. P-value (two-tailed): ', ...
                   num2str(sig),', Sens slope: ',num2str(sen), '(bounds: ',num2str(CIlower),', ',num2str(CIupper),')']));
               
               if (jj <= 2) ty1=9; ty2=5; else ty1=35; ty2=25; end
               text(1969,ty1, ['\bfp-val: ', num2str(sig)],'FontSize', 11)
               text(1969,ty2, ['\bfslope: ', num2str(sen)],'FontSize', 11)
           else
               disp(sprintf(['--> Trend is NOT significant at ',num2str(alp),' significance level']));
           end

       end  % <--- jj
   end   % <--- ii


   if (0)
       print(gcf, '-djpeg90', '-r400',  ['./AllAtmPhenomena_2trend_Stat.jpg'])
       print(gcf, '-depsc',  ['./AllAtmPhenomena_2trend_Stat.eps'])
       print(gcf, '-dpng',  ['./AllAtmPhenomena_2trend_Stat.png'])
   end
end
         
