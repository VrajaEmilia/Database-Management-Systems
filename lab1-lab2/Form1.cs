using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace lab2
{
    public partial class Form1 : Form
    {
        SqlConnection dbConn;
        SqlDataAdapter daParent, daChild;
        DataSet ds = new DataSet();
        SqlCommandBuilder cb,cbP;
        BindingSource bsParent, bsChild;
        string parent = ConfigurationManager.AppSettings.Get("parent");
        string child = ConfigurationManager.AppSettings.Get("child");
        string fk_col = ConfigurationManager.AppSettings.Get("fk_column");
        string fk_rel = ConfigurationManager.AppSettings.Get("fk_relation");
        public Form1()
        {

            InitializeComponent();
            string conStr = ConfigurationManager.AppSettings.Get("conStr");
            dbConn = new SqlConnection(conStr);

            daParent = new SqlDataAdapter("SELECT * FROM "+parent, dbConn);
            daChild = new SqlDataAdapter("SELECT * FROM "+child, dbConn);
            cb = new SqlCommandBuilder(daChild);
            cbP = new SqlCommandBuilder(daParent);
            daParent.Fill(ds, parent);
            daChild.Fill(ds, child);
            DataRelation dr = new DataRelation(fk_rel,
            ds.Tables[parent].Columns[fk_col],
            ds.Tables[child].Columns[fk_col]);
            ds.Relations.Add(dr);
            //data binding
            bsParent = new BindingSource();
            bsParent.DataSource = ds;
            bsParent.DataMember = parent;
            bsChild = new BindingSource();
            bsChild.DataSource = bsParent;
            bsChild.DataMember = fk_rel;
            dgvParent.DataSource = bsParent;
            dgvChild.DataSource = bsChild;

        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                daChild.Update(ds, child);
                daParent.Update(ds, parent);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}
