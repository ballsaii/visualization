        [file,path] = uigetfile('*.*','Select Astra file to Parmela',pwd);
        filepath = fullfile(path,file);
        data = importdata(filepath);

        % filter
        flag = data(:,10);
        cond = find(flag>=0);
        data = data(cond,:);

        % relative z,pz,time to absolute value

        z_ref = data(1,3);
        pz_ref = data(1,6);
        time_ref = data(1,7);

        z = [z_ref;z_ref+data(2:end,3)];
        pz = [pz_ref;pz_ref+data(2:end,6)];
        time = [time_ref;time_ref+data(2:end,7)]; % relative time
        % ignore z<0
        cond2 = find(z>0);
        % summary
        x = data(:,1);
        y = data(:,2);
        px = data(:,4);
        py = data(:,5);
        charge = data(:,8);
        
        ptotal = sqrt(px.^2+py.^2+pz.^2);
        Ek = p2E(ptotal);
        %%
        Ecut = prctile(Ek,0);
        Ecut = 2.3;
        condE = find(Ek>=Ecut);
       
        mean(x(condE))
        mean(y(condE))
        mean(Ek(condE))
        figure;histogram2(x(condE),y(condE),20,'DisplayStyle','Tile')