classdef monociclo
    %MONOCICLO Make your unicycle here
    %   Parameters, properties and unicycle galore!

    properties (Constant)
        rr = 0.2;
        rw = 0.071;
        l = 0.18632;
        mr = 0.47568;
        mb = 1.23913;
        mw = 0.30220;
        g = 9.8;
        jr = 0.013472;
        jw = 0.00077;
        jbr = 0.03937;
        jbw = 0.03458;
        nr = 71
        rer = 0.6;
        nw = 131.25;
        rew = 2.4;
        bvw = 0.1;
        bvr = 0.1;
    end

    properties %(Dependent)
        d=0;
        ktr=0;
        ker=0;
        ktw=0;
        kew=0;
    end
    
    methods (Static)
        function d = distancia(l)
            %d Calcs D
            %   Distance between body center of mass and reaction wheel
            d = 0.33660-l;
        end
        function ktr = konst_td()
            %ktr Calcs Ktr
            %   Torque constant of the reaction wheel motor
            ktr = (958.2*0.00706155183333)/(20);
        end
        function ker = konst_er()
            %ker Calcs Ktr
            %   Electrical constant of the reaction wheel motor
            ker = (12-0.53*0.6)/(118*2*pi/60);
        end
        function ktw = konst_tw()
            %ktw Calcs Ktw
            %   Torque constant of the wheel motor
            ktw = (250*0.00706155183333)/(5);
        end
        function kew = konst_ew()
            %ker Calcs Ktr
            %   Electrical constant of the reaction wheel motor
            kew = (12-0.3*2.4)/(80*2*pi/60);
        end        
    end
end