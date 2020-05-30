function [number] = findPatientNumber(PatientList,Patient)

number=0;

for i=1:size(PatientList,2)
    ListName=PatientList{i};
    if strcmp(PatientList{i},Patient)
        number=i;
    end
end
if number==0
    puase=10;
end
