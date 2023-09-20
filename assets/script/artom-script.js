/* 
 * Javascript diari Artom
 * Leonardo Celati - 17738117 - Unipi 
 */
 
 var visor = {
     currentPage: '',
     currentText: ''
 }
 
 var visorIdx;
 var visorLowerBound;
 var visorUpperBound;
 
 function swapVisor(idx) {
 
    visor['currentPage'] = diaryData['pages'][idx];
    thePage = $('#'+visor['currentPage']).html();
    document.getElementById("image").innerHTML = thePage;
    
    visor['currentText'] = diaryData['text'][idx];
    theText = $('#'+ visor['currentText']).html();
    document.getElementById("text").innerHTML = theText;
 }
 
 /* Visualizza pagina scelta */
 function moveToPage(direction) {
     
    switch(direction) {
        case 'left':
            if (visorIdx > visorLowerBound) {    
                newVisorIdx = visorIdx - 1;
            } else {
                return;
            }
                
            break;
        
        case 'right':
            if (visorIdx < visorUpperBound) {
                newVisorIdx = visorIdx + 1;
            } else {
                return;
            }
            
            break;
        
        default:
            return;
    }
    
    swapVisor(newVisorIdx);
    visorIdx = newVisorIdx;
 }
 
 function cleanInfoPopup() {
     $(".infoTable" ).remove();
 }
 
 function basicInfoTable() {
     return $("<table cellspacing='0' class='infoTable'></table>");
 }
 
 function appendInfoRow(theTable, theHeader, theText) {
 
     table.append(
        $("<tr></tr").append(
            $('<td></td>').addClass('info-header').text(theHeader)
        ).append(
            $('<td></td>').addClass('info-value').text(theText)
        )
    );
     
 }
 
 function person(id, orig) {
 
    cleanInfoPopup();

    table = basicInfoTable();

    var nameReal = diaryData['people'][id];
    var nameOrig = orig;
    
    appendInfoRow(table,'Nome nel testo', nameOrig);
    appendInfoRow(table,'Nome vero', nameReal);
    
    $(".content").append(table);
    $(".info").toggle();
 }
 
 function  place(id) {
 
    cleanInfoPopup();

    table = basicInfoTable();

    var place = diaryData['places'][id];
    
    appendInfoRow(table,'Nel testo', place[0]);
    appendInfoRow(table,'Descrizione', place[1]);
    appendInfoRow(table,'Nazione', place[2]);
    appendInfoRow(table,'Regione', place[3]);
    appendInfoRow(table,'Coordinate', place[4]);
    
    $(".content").append(table);
    $(".info").toggle();    
 }
 
// Function to show and hide the popup
function toggleInfoPopup() {
    $(".info").toggle();
    cleanInfoPopup();
}
 
 /* Inizializza la pagina */
 function init() {
    visorIdx = 0;
    visorLowerBound = 0;
    visorUpperBound = diaryData['pages'].length -1;    
    swapVisor(visorIdx);
 }
 
 
 