import java.util.ArrayList;
import java.util.Arrays;

class YJPlateau{
	String[][] plateau;
	ArrayList<String> reserveMoi;
	ArrayList<String> reserveAdv;
	private YokaiJavaEngineProtocol.YJSensPiece sensActuel;

	YJPlateau(YokaiJavaEngineProtocol.YJSensPiece sens){
		this.sensActuel = sens;
		if(sensActuel == YokaiJavaEngineProtocol.YJSensPiece.YJ_SUD){
			//plateau initial si on est le nord
			this.plateau = plateauNordInitial();
		}else {
			//plateau initial si on est le sud
			this.plateau = plateauSudInitial();
		}

		reserveMoi = new ArrayList<>();
		reserveAdv = new ArrayList<>();
	}

	public YokaiJavaEngineProtocol.YJSensPiece getSensActuel() {
		return sensActuel;
        }

    public YokaiJavaEngineProtocol.YJCase oneDimensionCaseTo2DimensionsCase(int numCase){
        return new YokaiJavaEngineProtocol.YJCase(numCase%5,numCase/5);
	}

	public void plateauMove(YokaiJavaEngineProtocol.YJCase Cfrom, YokaiJavaEngineProtocol.YJCase Cto){
	    int from = Cfrom.Line*5 + Cfrom.Col;
	    int to = Cto.Line*5 + Cto.Col;

	    capturePiece(plateau[to][0],plateau[to][2]);

	    plateau[to][0] = plateau[from][0];
	    plateau[to][1] = plateau[from][1];
	    plateau[to][2] = plateau[from][2];
	    plateau[from][0] = "v";
	    plateau[from][1] = "none";
	    plateau[from][2] = "neutre";
	}

	private void capturePiece(String namePieceCapt, String factionPieceCapt){
        if(!namePieceCapt.equals("v")) {
            if(namePieceCapt.equals("super_oni"))
                namePieceCapt = "oni";
            else if(namePieceCapt.equals("kodama_samourai"))
                namePieceCapt = "kodama";

            if(factionPieceCapt.equals("moi"))
                reserveAdv.add(namePieceCapt);
            else if(factionPieceCapt.equals("adv"))
                reserveMoi.add(namePieceCapt);
        }
    }

	public void plateauPlace(YokaiJavaEngineProtocol.YJSensPiece sens, YokaiJavaEngineProtocol.YJPiece piece, YokaiJavaEngineProtocol.YJCase casePiece) {
	    int caseOnPlateau = casePiece.Line*5 + casePiece.Col;

	    String sensName = "sud";
	    if(sens == YokaiJavaEngineProtocol.YJSensPiece.YJ_NORD)
	        sensName = "nord";

	    String faction = "moi";
	    if(sens != sensActuel)
	        faction = "adv";

	    String pieceName = yjPiecetoString(piece);

	    plateau[caseOnPlateau][0] = pieceName;
	    plateau[caseOnPlateau][1] = sensName;
	    plateau[caseOnPlateau][2] = faction;

	    if(faction.equals("moi")) {
            reserveMoi.remove(pieceName);
	    }
	    else{
	        int index = reserveAdv.indexOf(pieceName);
	        System.out.println("attempting to remove piece to index..." + index + " On " + reserveAdv.toString());
	        reserveAdv.remove(index);
	    }
	}

	private String yjPiecetoString(YokaiJavaEngineProtocol.YJPiece piece){
        switch(piece) {
            case YJ_KODAMA:
                return "kodama";
            case YJ_KIRIN:
                return "kirin";
            case YJ_ONI:
                return "oni";
                default: return "error";
        }
    }

    public void promotionPiece(String oldPiece, String oldSens, int toCol, int toLine){
        if(oldPiece.equals("oni") && oldSens.equals("sud") && toLine > 3)
            plateau[toLine * 5 + toCol][0] = "super_oni";

        else if(oldPiece.equals("oni") && oldSens.equals("nord") && toLine < 2)
            plateau[toLine * 5 + toCol][0] = "super_oni";

        else if(oldPiece.equals("kodama") && oldSens.equals("sud") && toLine > 3)
            plateau[toLine * 5 + toCol][0] = "kodama";

        else if(oldPiece.equals("kodama") && oldSens.equals("nord") && toLine < 2)
            plateau[toLine * 5 + toCol][0] = "kodama_samourai";

        
    }

	private String[][] plateauNordInitial(){
	    return new String[][]{
	            {"oni", "sud", "moi", "0"}, {"kirin", "sud", "moi", "1"}, {"koropokkuru", "sud", "moi", "2"}, {"kirin", "sud", "moi", "3"}, {"oni", "sud", "moi", "4"},
                {"v", "none", "neutre", "5"}, {"v", "none", "neutre", "6"}, {"v", "none", "neutre", "7"}, {"v", "none", "neutre", "8"}, {"v", "none", "neutre", "9"},
                {"v", "none", "neutre", "10"}, {"kodama", "sud", "moi", "11"}, {"kodama", "sud", "moi", "12"}, {"kodama", "sud", "moi", "13"}, {"v", "none", "neutre", "14"},
                {"v", "none", "neutre", "15"}, {"kodama", "nord", "adv", "16"}, {"kodama", "nord", "adv", "17"}, {"kodama", "nord", "adv", "18"}, {"v", "none", "neutre", "19"},
                {"v", "none", "neutre", "20"}, {"v", "none", "neutre", "21"}, {"v", "none", "neutre", "22"}, {"v", "none", "neutre", "23"}, {"v", "none", "neutre", "24"},
                {"oni", "nord", "adv", "25"}, {"kirin", "nord", "adv", "26"}, {"koropokkuru", "nord", "adv", "27"}, {"kirin", "nord", "adv", "28"}, {"oni", "nord", "adv", "29"}
	    };
	}

	private String[][] plateauSudInitial(){
	    return new String[][]{
	            {"oni", "sud", "adv", "0"}, {"kirin", "sud", "adv", "1"}, {"koropokkuru", "sud", "adv", "2"}, {"kirin", "sud", "adv", "3"}, {"oni", "sud", "adv", "4"},
                {"v", "none", "neutre", "5"}, {"v", "none", "neutre", "6"}, {"v", "none", "neutre", "7"}, {"v", "none", "neutre", "8"}, {"v", "none", "neutre", "9"},
                {"v", "none", "neutre", "10"}, {"kodama", "sud", "adv", "11"}, {"kodama", "sud", "adv", "12"}, {"kodama", "sud", "adv", "13"}, {"v", "none", "neutre", "14"},
                {"v", "none", "neutre", "15"}, {"kodama", "nord", "moi", "16"}, {"kodama", "nord", "moi", "17"}, {"kodama", "nord", "moi", "18"}, {"v", "none", "neutre", "19"},
                {"v", "none", "neutre", "20"}, {"v", "none", "neutre", "21"}, {"v", "none", "neutre", "22"}, {"v", "none", "neutre", "23"}, {"v", "none", "neutre", "24"},
                {"oni", "nord", "moi", "25"}, {"kirin", "nord", "moi", "26"}, {"koropokkuru", "nord", "moi", "27"}, {"kirin", "nord", "moi", "28"}, {"oni", "nord", "moi", "29"}
	    };
	}

	public String toString(){
	    StringBuilder all = new StringBuilder();
	    for(int i=0; i<30;i++){
	        all.append(Arrays.asList(plateau[i]).toString());
	        if(i != 29){
	            all.append(",");
	        }
	    }
	    return all.toString();
	}

	public String reserveToString(boolean moi){
        StringBuilder listePiecesInput = new StringBuilder();
        if(moi) {
            for (int i = 0; i < reserveMoi.size(); i++) {
                listePiecesInput.append(reserveMoi.get(i));
                if (i != reserveMoi.size() - 1)
                    listePiecesInput.append(",");
            }
        }else {
            for (int i = 0; i < reserveAdv.size(); i++) {
                listePiecesInput.append(reserveAdv.get(i));
                if (i != reserveAdv.size() - 1)
                    listePiecesInput.append(",");
            }
        }
        return listePiecesInput.toString();
    }
}
