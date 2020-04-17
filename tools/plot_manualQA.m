function plot_manualQA(sampleprefix)

assignin('base','sampleprefix',sampleprefix);
publish('report_html','outputDir',[sampleprefix 'html/']);
close all;
try
	% web([sampleprefix 'html/report_html.html']);
end