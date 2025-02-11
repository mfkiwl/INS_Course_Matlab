function [tk, r] = timebar(tStep, tTotal, msgstr)
% In PSINS Toolbox, a waitbar is always used to show the program running
% progress when needs a long time to processing. If the waitbar closed by user, 
% the processing abort; if the processing done, the waitbar will disappear
% automaticly.
%
% Prototype: tk = timebar(tStep, tTotal, msgstr)
% For initialization usage:
%       tk = timebar(tStep, tTotal, msgstr);
%           where tStep is the step increasing when called timebar once,
%           tTotlal is the total steps, if reached then waitbar disappears,
%           msgstr is a message string to be showed in the waitbar figure.
% In loop usage:        
%       tk = timebar;
%
% See also  resdisp, trjsimu, insupdate, kfupdate.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 07/10/2013
global tb_arg
    if nargin>=2
        tb_arg.tk = 1; tk = tb_arg.tk;
        tb_arg.tStep = tStep;
        tb_arg.tTotal = tTotal;
        tb_arg.tTotal001 = tTotal*0.01;
        tb_arg.tCur = 0;
        tb_arg.tOld = 0;
        tb_arg.rClosed = min(0.985, 1-2*tStep/tTotal);
%         tb_arg.time0 = cputime;
        if isfield(tb_arg, 'handle')
            if ishandle(tb_arg.handle)
                close(tb_arg.handle);
            end
        end
        if tStep==0 && tTotal==0, tb_arg.on=0; return; end      % timebar(0,0) stop all timebar     20/11/2022
        if tStep==1 && tTotal==1; tb_arg.on=1; return; end      % timebar(1,1) restart timebar
        if ~isfield(tb_arg,'on'), tb_arg.on=1; end  % default 'on'
        if tb_arg.on==0, return; end
        if nargin<3,  msgstr = [];    end
        tb_arg.handle = waitbar(0,[msgstr, ' Please wait...'], ...
            'Name','惯性导航课程设计-李郑骁', 'WindowStyle', 'non-modal', ...
            'CreateCancelBtn', 'delete(gcbf);');
        return;
    end
    tb_arg.tk = tb_arg.tk + 1; tk = tb_arg.tk;
    tb_arg.tCur = tb_arg.tCur + tb_arg.tStep;
    if tb_arg.on==0, r=tb_arg.tCur/tb_arg.tTotal; return; end
    if tb_arg.tCur-tb_arg.tOld > tb_arg.tTotal001
        r = tb_arg.tCur/tb_arg.tTotal;
        if ishandle(tb_arg.handle)
            if r>tb_arg.rClosed
                close(tb_arg.handle);
%                 fprintf('\tCPU time used is %.3f sec.\n\n', cputime-tb_arg.time0);
            else
                waitbar(r, tb_arg.handle);
                tb_arg.tOld = tb_arg.tCur;
            end            
        else
            if r<tb_arg.rClosed
                clear global tb_arg;
                error('PSINS processing is terminated by user.');
%                 disp('PSINS processing is terminated by user.\n');
%                 quit;
            end
        end
    end