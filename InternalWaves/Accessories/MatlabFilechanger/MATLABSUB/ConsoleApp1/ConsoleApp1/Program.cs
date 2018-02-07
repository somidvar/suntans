using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            MATLABSubWriter();
            MATLABMainSingleWriter();
            MATLABEnergyFluxWriter();
        }
        static void MATLABSubWriter()
        {
            for (int counter = 0; counter < 48; counter++)
            {
                StreamReader MATLABSUBReader = new StreamReader("D:\\github\\suntans\\InternalWaves\\Accessories\\MatlabFilechanger\\MATLABSUB\\MATLABSUBMother.sh");
                string BodyFile = MATLABSUBReader.ReadLine() + "\n";
                BodyFile += MATLABSUBReader.ReadLine()+"\n";
                MATLABSUBReader.ReadLine();
                BodyFile += string.Format("#PBS -N MATLABJob{0}\n",counter+70000);
                BodyFile += MATLABSUBReader.ReadToEnd()+"\n";
                MATLABSUBReader.Close();
                BodyFile += "matlab -nodisplay </lustre1/omidvar/work-directory_0801/MatlabFiles/MainSingle";
                BodyFile += string.Format("{0}", counter + 70000);
                BodyFile+=@".m> matlab_${PBS_JOBID}.out";
                string OutputAddress = string.Format("D:\\github\\suntans\\InternalWaves\\Accessories\\MatlabFilechanger\\MATLABSUB\\MATLABSub{0}.sh", counter+70000);
                StreamWriter MATLABSUBWriter = new StreamWriter(OutputAddress);
                MATLABSUBWriter.Write(BodyFile);
                MATLABSUBWriter.Close();
            }
        }
        static void MATLABMainSingleWriter()
        {
            StreamReader MainSingleStreamReader = new StreamReader("D:\\github\\suntans\\InternalWaves\\Accessories\\MatlabFilechanger\\MATLABSUB\\MainSingleMother.m");
            for (int counterSkipper = 0; counterSkipper < 8; counterSkipper++)
                MainSingleStreamReader.ReadLine();
            string MainSingleBody = MainSingleStreamReader.ReadToEnd();
            MainSingleStreamReader.Close();
            for (int counter = 0; counter < 48; counter++)
            {
                double DiurnalTideOmega, SemiDiurnalTideOmega, WindTauMax, PycnoclineDepthIndex, BathymetryXLocationAtPycnoclineIndex;
                DiurnalTideOmega = SemiDiurnalTideOmega = WindTauMax = PycnoclineDepthIndex = BathymetryXLocationAtPycnoclineIndex = -9999;
                switch (counter % 4)
                {
                    case 0:
                        DiurnalTideOmega = 0;
                        SemiDiurnalTideOmega = 0;
                        break;
                    case 1:
                        DiurnalTideOmega = 2 * Math.PI / (23.93 * 3600);
                        SemiDiurnalTideOmega = 0;
                        break;
                    case 2:
                        DiurnalTideOmega = 0;
                        SemiDiurnalTideOmega = 2 * Math.PI / (12.42 * 3600);
                        break;
                    case 3:
                        DiurnalTideOmega = 2 * Math.PI / (23.93 * 3600);
                        SemiDiurnalTideOmega = 2 * Math.PI / (12.42 * 3600);
                        break;
                    default:
                        break;
                }
                switch (Convert.ToInt16(counter/12))
                {
                    case 0:
                        WindTauMax = 0;
                        break;
                    case 1:
                        WindTauMax = 2.5e-5;
                        break;
                    case 2:
                        WindTauMax = 5e-5;
                        break;
                    case 3:
                        WindTauMax = 7.5e-5;
                        break;
                    default:
                        break;
                }
                if ((counter % 12) < 4)
                {
                    PycnoclineDepthIndex = 20;
                    BathymetryXLocationAtPycnoclineIndex = 14;
                }
                else if ((counter % 12) < 8)
                {
                    PycnoclineDepthIndex = 30;
                    BathymetryXLocationAtPycnoclineIndex = 20;
                }
                else if ((counter % 12) < 12)
                {
                    PycnoclineDepthIndex = 40;
                    BathymetryXLocationAtPycnoclineIndex = 24;
                }
                string MainSingleString = "close all;\r\nclear all;\r\nclc\r\n\r\n";
                MainSingleString += string.Format("CaseNumber={0};\r\n", counter + 70000);
                MainSingleString += string.Format("DiurnalTideOmega={0};\r\n", DiurnalTideOmega.ToString("e4"));
                MainSingleString += string.Format("SemiDiurnalTideOmega={0};\r\n", SemiDiurnalTideOmega.ToString("e4"));
                MainSingleString += string.Format("WindTauMax={0};\r\n", WindTauMax);
                MainSingleString += string.Format("PycnoclineDepthIndex={0};\r\n", PycnoclineDepthIndex);
                MainSingleString += string.Format("BathymetryXLocationAtPycnoclineIndex={0};\r\n", BathymetryXLocationAtPycnoclineIndex);
                MainSingleString += MainSingleBody;
                MainSingleString=MainSingleString.Remove(MainSingleString.LastIndexOf('\n'));
                MainSingleString = MainSingleString.Remove(MainSingleString.LastIndexOf('\n'));
                MainSingleString = MainSingleString.Remove(MainSingleString.LastIndexOf('\n'));
                MainSingleString = MainSingleString.Remove(MainSingleString.LastIndexOf('\n'));
                MainSingleString += string.Format("EnergyFluxCalculator{0}", counter + 70000);
                MainSingleString += "(DataPath,CaseNumber,OutputAddress,KnuH,KappaH,g,InterpolationEnhancement,XEndIndex,DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,TimeEndIndex,PycnoclineDepthIndex,BathymetryXLocationAtPycnoclineIndex,SapeloFlag);\r\n";
                string outputAddress = string.Format("D:\\github\\suntans\\InternalWaves\\Accessories\\MatlabFilechanger\\MATLABSUB\\MainSingle{0}.m", counter + 70000);
                StreamWriter MainSingleStreamWriter = new StreamWriter(outputAddress);
                MainSingleStreamWriter.Write(MainSingleString);
                MainSingleStreamWriter.Close();
            }
        }
        static void MATLABEnergyFluxWriter()
        {
            StreamReader EnergyFluxCalculatorStreamReader = new StreamReader("D:\\github\\suntans\\InternalWaves\\Accessories\\MatlabFilechanger\\MATLABSUB\\EnergyFluxCalculatorMother.m");
            for (int counterSkipper = 0; counterSkipper < 12; counterSkipper++)
                EnergyFluxCalculatorStreamReader.ReadLine();
            string EnergyFluxBody = EnergyFluxCalculatorStreamReader.ReadToEnd();
            EnergyFluxCalculatorStreamReader.Close();
            for (int counter = 0; counter < 48; counter++)
            {
                string EnergyFluxString = string.Format("function EnergyFluxCalculator{0}", counter + 70000);
                EnergyFluxString += "(DataPath,CaseNumber,OutputAddress,KnuH,KappaH,g,InterpolationEnhancement,XEndIndex,DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,TimeEndIndex,PycnoclineDepthIndex,BathymetryXLocationAtPycnoclineIndex,SapeloFlag)\r\n";
                EnergyFluxString += EnergyFluxBody;
                string outputAddress = string.Format("D:\\github\\suntans\\InternalWaves\\Accessories\\MatlabFilechanger\\MATLABSUB\\EnergyFluxCalculator{0}.m", counter + 70000);
                StreamWriter EnergyFluxCalculatorWriter = new StreamWriter(outputAddress);
                EnergyFluxCalculatorWriter.Write(EnergyFluxString);
                EnergyFluxCalculatorWriter.Close();
            }
        }
    }
}
