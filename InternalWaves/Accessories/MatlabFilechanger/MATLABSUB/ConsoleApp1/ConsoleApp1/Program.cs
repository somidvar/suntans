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
            for (int counter = 0; counter < 100; counter++)
            {
                StreamReader MATLABSUBReader = new StreamReader("C:\\Users\\omidvar\\Desktop\\MatlabFilechanger\\MATLABSUB\\MATLABSubMother.sh");
                string BodyFile = MATLABSUBReader.ReadLine() + "\n";
                BodyFile += MATLABSUBReader.ReadLine()+"\n";
                BodyFile += string.Format("#PBS -N MATLABJob{0}\n",counter+10000);
                BodyFile += MATLABSUBReader.ReadToEnd()+"\n";
                MATLABSUBReader.Close();
                BodyFile += "matlab -nodisplay </lustre1/omidvar/work-directory_0801/MatlabFiles/MainSingle";
                BodyFile += string.Format("{0}", counter + 10000);
                BodyFile+=@".m> matlab_${PBS_JOBID}.out";
                string OutputAddress = string.Format("C:\\Users\\omidvar\\Desktop\\MatlabFilechanger\\MATLABSUB\\MATLABSub{0}.sh", counter+10000);
                StreamWriter MATLABSUBWriter = new StreamWriter(OutputAddress);
                MATLABSUBWriter.Write(BodyFile);
                MATLABSUBWriter.Close();
            }

        }
    }
}
