package com.fortinet.devqa.checklist;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

import com.fortinet.devqa.Util;

public class DataCollector {
	
	static String Title = "";
	static String ModelNumber="";
	static String version="";
	static String BuildNumber="";
	
	
	
public static void main(String[] args) {
		
		String tmp=fgtInfo("172.18.43.202");
		
		Util.logd(tmp);
		splits(tmp);
		
		Util.loger(header());
		

	}	
	
	
	static void splits(String fgtInfo){
		
		String key1= "# Version:";
	    int index1 = fgtInfo.indexOf(key1);
		String fgtInfo2=fgtInfo.substring(index1+key1.length()+1); // +1 for leading blank
		
		String[] parts =fgtInfo2.split(" ");
		ModelNumber = parts[0];
		BuildNumber= parts[1];
		if (parts.length>2) Util.logd("ERROR, it's GA build"+fgtInfo2);
	//	ModelNumber=Info2.substring(0,Info2.indexOf(" "));
	//	BuildNumber= Info2.substring(Info2.indexOf(" "));
		
		
	}
	
/**
========================================
Feature Description: 
Product: Fortigate
Test checklist approved by: 
Test checklist approved on:  
Product Model Number (If applicable): FortiGate-100D
Version:  v6.2.0
Build Number:v6.2.0,build6900,190308 (P1900_R4632_D8376)
QA Engineer: Aiyan Ma
Mantis ID:  541596, 541248
Code Coverage Percentage: 57%
Code Coverage URL: https://testcoverage.corp.fortinet.com/job/Test_Coverage_Report/23076/
Code Coverage Comment (required if<70%): 
========================================	

*/	
	static String header(){
		
		String CRL="\t\n";
		String sb1 = new String("========================================" 
				+ CRL+"Feature Description: "
				+ CRL+"Product: Fortigate " 
				+ CRL+"Test checklist approved by: "
				+ CRL+"Test checklist approved on:  "
				+ CRL+"Product Model Number (If applicable):");
		
	sb1+=ModelNumber;
	sb1+=CRL+"Build Number:"+BuildNumber;
	sb1+=CRL+"QA Engineer: Aiyan Ma"
			+CRL+"Mantis ID: "
			+CRL+"Code Coverage Percentage:"
			+CRL+"Code Coverage URL: https://testcoverage.corp.fortinet.com/job/Test_Coverage_Report/"
			+CRL+"Code Coverage Comment (required if<70%): "
			+CRL+"========================================	"
			;
		
	 return sb1;
	}
	
	
	
	
	static String fgtInfo (String ip){
		
		String cmd = "ssh admin@"+ip+" get sys status | grep Version:";
//		String rst =
		
		String rst= runCmdwithResult(cmd);
		
		Util.logd(rst);
		return rst;
		 
	}
	
	
	void createCheckList() throws FileNotFoundException,
			UnsupportedEncodingException {
		
		PrintWriter writerDNS = new PrintWriter(
				"/tmp/10k-20k-fqdn_win2012.txt", "UTF-8");
		writerDNS.println("Name,IPv4Address"); // add header

		PrintWriter writerFGT = new PrintWriter("/tmp/1020k.txt", "UTF-8");
	}
	
public static String runCmdwithResult(String cmd) {
		
		String rst = null, e=null;

		try {
			Util.loger("cmd is: " + cmd);

			Process proc = Runtime.getRuntime().exec(cmd);

			// retrieve and process the output
			BufferedReader stdInput = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			BufferedReader stdError = new BufferedReader(new InputStreamReader(proc.getErrorStream()));

			// read the output from the command
			System.out.println("Here is the standard output of the command:\n");
			
		//	while ((rst = stdInput.readLine()) != null) 
			{
				rst = stdInput.readLine();
				System.out.println(rst);
			
							
			}
		
			// read any errors from the attempted command
			System.out.println("Here is the standard error of the command (if any):\n");
			while ((e = stdError.readLine()) != null) {
				System.out.println(e);
			}			
			 

		} catch (IOException ee) {
			// TODO Auto-generated catch block
			ee.printStackTrace();
		}
		Util.logd("rst is"+rst);
		return rst;
	}
}
