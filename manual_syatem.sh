#                                                                        بسم الله الرحمن الرحيم 
#!/bin/bash
#Name: Majd Abdeddin     ID: 1202923 
commands=("df" "du" "lsblk" "ps" "pstree" "id" "groups" "uptime" "uname" "who" "date" "cal" "ip" "iconfig" "echo" "ls" "touch" "pwd" "cat" "clear")  # Add more commands as needed



generate_command_manual(){
    cmd=$1
    #command Description
    if [ $cmd == "ip" ];then
        cmd_des=$(man $cmd | grep -m 1 -A 4 "^NAME" | grep -v "^NAME")
    else
        cmd_des=$(man $cmd | grep -m 1 -A 4 "^DESCRIPTION" | grep -v "^DESCRIPTION")
    fi
    #Version History
    if [ $cmd == "ip"  -o  $cmd == "clear"  -o  $cmd == "pstree" ] ;then
        cmd_ver=`$cmd -V`
    else
        cmd_ver=`$cmd --version | head -n 1 `
    fi
    # Example


    cmd_ep=$cmd
    if [ "$cmd" == "ip" ]
    then 
        cmd_ep=">$cmd addr"
        cmd_ex=`$cmd addr`

    elif [ "$cmd"  == "cat" ]
    then
        cd test
        echo "Hi how are you ?" >> test.txt
        cmd_ep="$cmd test.txt"
        cmd_ex=`cat test.txt`
        rm test.txt
        cd ..

    elif [ "$cmd"  == "touch" ]
    then
        cd test 
        touch test.txt
        cmd_ep="$cmd test.txt"
        cmd_ex=`ls`
        rm test.txt
        cd ..

    elif [ "$cmd" == "echo" ]
    then
        cmd_ep=">echo Hello World " 
        cmd_ex=`echo "Hello World " `

    else
        cmd_ex=`$cmd`
    fi



    #Related Commands
    cmd_re=`grep ^$cmd compgen-c.txt`

    #create a manual file for command 
    echo -e "\e[32m \e[1mName\e[0m: \e[1;33m $cmd\e[1m\e[0m " > "$cmd.txt"  
    echo "_______________________ _____________________________________________________________________" >> $cmd.txt
    echo -e "\e[32m \e[1mDescription\e[0m: "$cmd_des >> $cmd.txt
    echo "___________________ _________________________________________________________________________" >> $cmd.txt 
    echo -e "\e[32m \e[1mVersion History\e[0m: " $cmd_ver >> $cmd.txt
    echo "___________ _________________________________________________________________________________" >> $cmd.txt
    echo -e "\e[32m \e[1mExample\e[0m:  >$cmd_ep\n" $cmd_ex >> $cmd.txt
    echo "_____________________ _______________________________________________________________________" >> $cmd.txt
    echo -e "\e[32m \e[1mRelated Commands\e[0m : " `echo $cmd_re | tr ' ' ','  ` >> $cmd.txt
}

notexit=0 
for command in "${commands[@]}"; do
    if [ ! -e "$command".txt ]; then

        notexist=$((not_exist + 1))
    fi
done
if [ $notexist -eq ${#commands[@]} ]; then
   
    for command in "${commands[@]}"; do
        generate_command_manual "$command"
    done
else
    
    for command in "${commands[@]}"; do
        if [ -e "$command".txt ]; then
         
            echo -e " \e[1;33m $command\e[1m\e[0m.txt --> \e[32m \e[1mdone\e[0m" #
        else
          
            echo -e "The manual of $command does not exist"
            read -p "If you want to generate it, enter [y] else enter [n]  " ch
            if [ $ch == "y" ]; then
               
                generate_command_manual "$command"
            fi
        fi
    done
fi
clear

checkDescription(){
    cmdD=$1
      if [ $cmdD == "ip" ];then
         des_1=$(man $cmdD | grep -m 1 -A 4 "^NAME" | grep -v "^NAME")
    else
         des_1=$(man $cmdD | grep -m 1 -A 4 "^DESCRIPTION" | grep -v "^DESCRIPTION") 
    fi
    des_2=$(cut -d : -f 2 $cmdD.txt  | head -n 3 | tail -n -1) #cut -d : -f 2 $cmdD.txt  | head -n 3 | tail -n -1
    
    des_1=`echo $des_1 | tr -d '\n'`

    echo -e "the\e[32m \e[1mDescription\e[0m from man --> $des_1"
    echo "==============="
    echo -e "the \e[32m \e[1mDescription\e[0m from my manual --> $des_2"

   echo -e "\nVerify the  \e[32m \e[1mDescription\e[0m above. Does it match the expected output?"
    read -p "Enter 'y' for yes, 'n' for no: " answer
    if [ "$answer" != "y" ]; then
        echo "Verification failed. Please review the generated manual for $cmdD.txt"
    else
        echo "Verification successful."
    fi
}

checkVersion(){
    cmdVi=$1
    if [ $cmdVi == "ip" ] || [ $cmdVi == "clear" ] || [ $cmdVi == "pstree" ] ;then
        ver1=`$cmdVi -V`
    else
        ver1=`$cmdVi --version | head -n 1 `
    fi
    ver2=$(cut -d : -f 2 $cmdVi.txt | head -n 5 | tail -n -1) #
    
    ver1=`echo $ver1 | tr -d '\n'`
 
    echo -e "the\e[32m \e[1mVersion History\e[0m from man --> $ver1"
    echo "==============="
    echo -e "the\e[32m \e[1mVersion History\e[0m from my manual --> $ver2"
    
    echo -e "\nVerify the  Version History above. Does it match the expected output?"
    read -p "Enter 'y' for yes, 'n' for no: " answer
    if [ "$answer" != "y" ]; then
        echo "Verification failed. Please review the generated manual for $cmdVi.txt"
    else
        echo "Verification successful."
    fi
}

checkExecute(){
    cmde=$1
    echo "Executing command: $cmde"
    if [ $cmde == "touch" ];then
        cd test
        echo ">$cmde test.txt"
        echo `$cmde test.txt`
        ls
        rm test.txt
        cd ..

    elif [ "$cmde" == "ip" ]
        then 
        echo ">$cmde addr"
        echo `$cmde addr`

    
    elif [ $cmde == "cat" ];then
        echo -e ">$cmde $cmde.txt"
        cat cat.txt
    
    elif [ $cmde == "echo" ];then
        echo `echo "yes it print "`
    
    else
        echo `$cmde`
    fi

    echo -e "\nVerify the example above. Does it match the expected output?"
    read -p "Enter 'y' for yes, 'n' for no: " answer
    if [ "$answer" != "y" ]; then
        echo "Verification failed. Please review the generated manual for $cmde.txt"
    else
        echo "Verification successful."
    fi
} 



verification(){
    while true ;do

        echo -e "                          *************************** Verification ***************************"
        read -p "man$ " cmdV
     
        if [ -e $cmdV.txt ];then
            echo "[1]Check description"
            echo "[2]Check Version"
            echo "[3]Check Execute "
            echo "[4]Back"

            read -p "Enter your choice:" choice
            case $choice in 
                1) checkDescription $cmdV ;;
                2) checkVersion $cmdV ;;
                3) checkExecute $cmdV ;;
                4) break ;;
                *) echo "wrong value" ;;
            esac
        else
            echo -e "No manual entry for \e[1;33m$cmdV\e[1m\e[0m" #
            break
        fi
    done    
}
#verification

commandRecommendation(){ 
    
    cmdR=$1

    case $cmdR in
        "df" | "du" | "lsblk" | "uname" )
            group="systemInfo"
            commandsR=("df" "du" "lsblk" "uname")
        ;;
        "ps" | "pstree" )
            group="processManagement"
            commandsR=("ps" "pstree")
        ;;
        "id" | "groups" | "who" )
            group="userManagement"
           commandsR=("id" "groups" "who")
        ;;
        "date" | "cal" | "uptime" )
            group="timeInfo "
            commandsR=("date" "cal" "uptime")
        ;;
        "ip" | "ifconfig" )
            group="networkInfo"
            commandsR=("ip" "ifconfig")
        ;;
        "ls" | "touch" | "pwd" | "cat" | "echo" )
            group="fileManagement"
            commandsR=("ls" "touch" "pwd" "cat" "echo")
        ;;
        "clear" )
            group="Clear"
            commandsR=("clear")
        ;;
        * )
            group="0"
        ;;
    esac

        if [ $group != "0" ]; then
            echo -e "The command '$cmdR' belongs to group \e[1;33m$group\e[1m\e[0m."
            echo "the commands we recommend is :"
            for cmd in "${commandsR[@]}"; do
                if [ "$cmd" != "$cmdR" ]; then
                    echo -e "\e[1;33m$cmd\e[1m\e[0m" 
                fi
            done
        else
            echo "The command '$cmdR' is not recognized."
        fi


       
}
commandSearch(){
    echo -e "                              ************************ Searching ***********************"
    read -p "man$ " cmdS
   while true ; do
    if [  -e $cmdS.txt  ];then
            echo "[1] show the manual of the command  "
            echo "[2] show the description of the command "
            echo "[3] show the Version of the command "
            echo "[4] show the recommend commands "
            echo "[5] change the command  "
            echo "[6] back"
            
            read -p "Enter your choice: " choice 
            case $choice in
            1)
                echo ""
                echo -e "========================================================================================================"        
                cat $cmdS.txt
                echo ""
                echo -e "========================================================================================================   "
                echo ""
            ;;
            2)
                echo ""
                echo -e "========================================================================================================  "
                des=$(cut -d : -f 2 $cmdS.txt  | head -n 3 | tail -n -1)
                echo -e "\e[32m \e[1mDescription\e[0m: $des" #
                echo "" 
                echo -e " ========================================================================================================   "
                echo ""
            ;;
            3)
                echo ""
                echo -e "========================================================================================================= "  
                ver=$(cut -d : -f 2 $cmdS.txt | head -n 5 | tail -n -1)
                echo -e  "\e[32m \e[1mVersion History\e[0m: $ver"
                echo ""
                echo -e "======================================================================================================== "  
                echo ""
            ;;
            4) 
                echo ""
                echo -e "======================================================================================================== "  
                commandRecommendation $cmdS 
                echo ""
                echo -e "========================================================================================================"  
                echo ""
            ;;
            5) 
                echo ""
                echo -e "======================================================================================================== "  
                read -p "Enter the command: " cmdS
                echo ""
                echo -e "======================================================================================================== "  
                echo ""
            ;;
            6) 
            
            break ;;

            *) echo "wrong value" ;;
            esac
        else
            echo -e "No manual entry for \e[1;33m $cmdS\e[1m\e[0m"
            break     
    fi
    done
}
menu(){

    echo -e "                               *************** Welcome in my manual System ************             "
    
    while true;do
        echo -e "                             ************************ Main ************************"
        echo -e "[1]showe the files in the manual"
        echo -e "[2]show the manual of the command"
        echo -e "[3]Verification "
        echo -e "[4]Searching "
        echo -e "[5]exit"
        read -p "Enter your choice: " ch
        case $ch in 
            1) 
               echo ""
                echo -e "======================================================================================================== "
                i=1
                for command in "${commands[@]}"; do
                    echo -e "$i) \e[1;33m $command\e[1m\e[0m.txt" #
                    i=$((i+1))
                 done  
                echo ""
                echo -e "======================================================================================================== "
            ;;
            2) 
                read -p "man$" cmdMa #
                echo ""
                echo -e "========================================================================================================"        
                cat $cmdMa.txt
                echo ""
                echo -e "========================================================================================================   "
                echo ""
            ;;
            3) 
                echo ""
                echo -e "========================================================================================================"
                verification
                echo ""
                echo -e "======================================================================================================== "
            ;;
            
            4)
                echo ""
                echo -e "======================================================================================================== "
                commandSearch
                echo ""
                echo -e "========================================================================================================"
             ;;
            
            5) 
                echo -e "\e[32m \e[1mGoodbye!\e[0m" 
                exit 0 ;;

            *) "wrong value" ;;
        esac
    done
}

menu
