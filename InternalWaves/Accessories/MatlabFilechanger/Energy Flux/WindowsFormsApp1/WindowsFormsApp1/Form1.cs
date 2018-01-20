using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace WindowsFormsApp1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            StreamReader MainBatchStreamReader = new StreamReader("C:\\Users\\omidvar\\Desktop\\MatlabFilechanger\\Energy Flux\\MainSingle.m");
            string MainBody = MainBatchStreamReader.ReadToEnd();
            MainBatchStreamReader.Close();
            StreamReader EnergyFluxCalculatorStreamReader = new StreamReader("C:\\Users\\omidvar\\Desktop\\MatlabFilechanger\\Energy Flux\\EnergyFluxCalculator.m");
            string EnergyFlux = EnergyFluxCalculatorStreamReader.ReadToEnd();
            EnergyFluxCalculatorStreamReader.Close();
            for (int counter = 0; counter < 100; counter++)
            {
                string MainBacthConcept = "close all;\r\nclear all;\r\nclc;\r\n\r\n";
                MainBacthConcept += string.Format("counter={0}", counter + 10000);
                MainBacthConcept += ";\r\n";
                MainBacthConcept += MainBody;
                MainBacthConcept += string.Format("EnergyFluxCalculator{0}", counter + 10000);
                MainBacthConcept += "(DataPath,CaseNumber,KnuH,KappaH,g,InterpolationEnhancement,XLocation,XEndIndex,DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,TimeEndIndex,PycnoclineDepthIndex,BathymetryXLocationAtPycnoclineIndex,SapeloFlag);\r\n";
                string outputAddress = string.Format("C:\\Users\\omidvar\\Desktop\\MatlabFilechanger\\Energy Flux\\MainSingle{0}.m", counter + 10000);
                StreamWriter MainBatchWriter = new StreamWriter(outputAddress);
                MainBatchWriter.Write(MainBacthConcept);
                MainBatchWriter.Close();

                string EnergyFluxConcept = string.Format("function EnergyFluxCalculator{0}",counter+10000);
                EnergyFluxConcept+="(DataPath,CaseNumber,KnuH,KappaH,g,InterpolationEnhancement,XLocation,XEndIndex,DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,TimeEndIndex,PycnoclineDepthIndex,BathymetryXLocationAtPycnoclineIndex,SapeloFlag)\r\n";
                EnergyFluxConcept += EnergyFlux;
                outputAddress = string.Format("C:\\Users\\omidvar\\Desktop\\MatlabFilechanger\\Energy Flux\\EnergyFluxCalculator{0}.m", counter + 10000);
                StreamWriter EnergyFluxCalculatorWriter = new StreamWriter(outputAddress);
                EnergyFluxCalculatorWriter.Write(EnergyFluxConcept);
                EnergyFluxCalculatorWriter.Close();
            }
        }
    }
}
