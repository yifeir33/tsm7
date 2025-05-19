% Spring Element Stiffness
function kelem = ses(k)
    kelem = [k -k; -k k];

end