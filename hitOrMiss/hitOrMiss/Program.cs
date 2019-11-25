using System;
using System.Collections.Generic;

namespace hitOrMiss
{
    class WorkingCache
    {
        public static void Main()
        {
            Cache cache = new Cache(16, 1, 8);
            int[] addressList = { 0x0000, 0x0004, 0x000c, 0x2200, 0x00d0, 0x00e0, 0x1130, 0x0028,
                                  0x113c, 0x2204, 0x0010, 0x0020, 0x0004, 0x0040, 0x2208, 0x0008,
                                  0x00a0, 0x0004, 0x1104, 0x0028, 0x000c, 0x0084, 0x000c, 0x3390,
                                  0x00b0, 0x1100, 0x0028, 0x0064, 0x0070, 0x00d0, 0x0008, 0x3394};
            byte[] ans = cache.IGTNMH(addressList);
            Console.WriteLine("The misses are {1} and the hits are {0}", ans[0], ans[1]);
        }
    }
    public class Cache
    {
        public List<LinkedList<int>> sets = new List<LinkedList<int>>();
        // public byte addrFormat;
        public byte l;
        public byte n;
        public byte k;
        public static byte size;

        static Cache()
        {
            size = 128;
        }

        public Cache(byte l = 16, byte n = 1, byte k = 8)
        {
            this.l = l;
            this.n = n;
            this.k = k;
            for (int i = 0; i < n; i++)                              // insert linked list of tags that implement LRU by popping the last inserted 
            {
                LinkedList<int> tags = new LinkedList<int>();
                sets.Add(tags);
            }
            Console.WriteLine("L: {0}\nN: {1}\nK: {2}",l,n,k);
        }
        public byte[] IGTNMH(int[] addresses)
        {
            byte[] hitsAndMiss = { 0, 0 };
            short setNoMask = 0;
            int tagMask = 0;
            int tag = 0;
            int setIndex;
            int diff = 0;
            int setbits = (int)Math.Log(this.n, 2);
            switch (setbits)
            {
                case 0:
                    setNoMask = 0;
                    tagMask = 65520;
                    break;
                case 1:
                    setNoMask = 16;
                    tagMask = 65504;
                    break;
                case 2:
                    setNoMask = 48;
                    tagMask = 65472;
                    break;
                case 3:
                    setNoMask = 112;
                    tagMask = 65408;
                    break;
                default:
                    Console.WriteLine("Not enough space.");
                    break;
            }
            //Console.WriteLine(addressFormat[1]);
            for (int i = 0; i < addresses.Length; i++)
            {
                setIndex = setNoMask & addresses[i];
                setIndex = setIndex >> 4;
                tag = tagMask & addresses[i];
                diff = 4 + setbits;
                tag = tag >> diff;
                // hit 
                if (this.sets[setIndex].Contains(tag))
                {
                    this.sets[setIndex].Remove(tag);
                    this.sets[setIndex].AddFirst(tag);
                    Console.WriteLine("0x{0:x4} : HIT", addresses[i]);
                    hitsAndMiss[0]++;
                } // empty list or space for another tag (compulsory miss)
                else if (this.sets[setIndex] == null || this.sets[setIndex].Count < this.k)
                {
                    this.sets[setIndex].AddFirst(tag);
                    Console.WriteLine("0x{0:x4} : MISS", addresses[i]);
                    hitsAndMiss[1]++;
                }
                // miss
                else
                {
                    this.sets[setIndex].RemoveLast();
                    this.sets[setIndex].AddFirst(tag);
                    Console.WriteLine("0x{0:x4} : MISS", addresses[i]);
                    hitsAndMiss[1]++;
                }
                //     }
            }
            return hitsAndMiss;
        }
    }
}
