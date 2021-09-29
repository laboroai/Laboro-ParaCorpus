conf_dir='/home/ubuntu/data/post_conf/'

function post()
{
start_index=$1
end_index=$2
for k in $(seq -f %05g $start_index $end_index)
do
    /home/ubuntu/bitextor/bitextor.sh -j 1 -s $conf_dir'cc_1830_'$k'.yaml'
done &
}

function test_post()
{
start_index=$1
end_index=$2
echo $start_index', '$end_index
for k in $(seq $start_index $end_index)
do
echo "echoing ... "$conf_dir" "$k
done &
}

start_index=1
for j in {1..160}
do
end_index=$(($start_index+151-1))
post $start_index $end_index
start_index=$(($end_index+1))
done
for j in {161..330}
do
end_index=$(($start_index+152-1))
post $start_index $end_index
start_index=$(($end_index+1))
done


