package com.lanyuan.entity;

import java.io.Serializable;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Properties;

import org.apache.commons.lang.time.DateFormatUtils;
import org.hyperic.sigar.CpuInfo;
import org.hyperic.sigar.CpuPerc;
import org.hyperic.sigar.FileSystem;
import org.hyperic.sigar.FileSystemUsage;
import org.hyperic.sigar.Mem;
import org.hyperic.sigar.Sigar;
import org.hyperic.sigar.Swap;
/**
 * 服务器状态
 * @author Administrator
 *
 */
public class ServerStatus implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String javaServer;
	private String deployPath;
	private String serverTime;
	private String serverName;
	private String serverOs;
	private String javaHome;
	private String javaTmpPath;
	private String javaVersion;
	private long jvmTotalMem;
	private long jvmMaxMem;
	private long jvmFreeMem;
	
	private long totalMem;
	private long usedMem;
	private long freeMem;
	
	private long totalSwap;
	private long usedSwap;
	private long freeSwap;
	
	private String cpuUsage;//CPU使用率
	private String ip;//本机ＩＰ
	
	
	private List<CpuInfos> cpuInfos = new ArrayList<CpuInfos>();
	
	private List<DiskInfos> diskInfos = new ArrayList<DiskInfos>();
	
	private boolean sigarInitError;
	
	 /**
		 * 返回服务系统信息
		 * @throws Exception 
		 */
		public static ServerStatus findServerStatus() throws Exception {
			ServerStatus status = new ServerStatus();
			status.setServerTime(DateFormatUtils.format(Calendar.getInstance(), "yyyy-MM-dd HH:mm:ss"));
			status.setServerName(System.getenv().get("COMPUTERNAME"));

			Runtime rt = Runtime.getRuntime();
			try {
				status.setIp(InetAddress.getLocalHost().getHostAddress());
			} catch (Exception e) {
				status.setIp("无法获取服务器的IP");
			}
			status.setJvmTotalMem(rt.totalMemory() / (1024 * 1024));
			status.setJvmFreeMem(rt.freeMemory() / (1024 * 1024));
			status.setJvmMaxMem(rt.maxMemory()/ (1024 * 1024));
			Properties props = System.getProperties();
			status.setServerOs(props.getProperty("os.name") + " " + props.getProperty("os.arch") + " " + props.getProperty("os.version"));
			status.setJavaHome(props.getProperty("java.home"));
			status.setJavaVersion(props.getProperty("java.version"));
			status.setJavaTmpPath(props.getProperty("java.io.tmpdir"));

			Sigar sigar = new Sigar();
			findServerCpuInfo(sigar, status);
			findServerDiskInfo(sigar, status);
			findServerMemoryInfo(sigar, status);
			
			return status;
		}
		public static void findServerCpuInfo(Sigar sigar, ServerStatus status) {
			try {
				CpuInfo infos[] = sigar.getCpuInfoList();
				CpuPerc cpuList[] = sigar.getCpuPercList();
				double totalUse = 0L;
				for (int i = 0; i < infos.length; i++) {
					CpuPerc perc = cpuList[i];
					CpuInfos cpuInfo = new CpuInfos();
					cpuInfo.setId(infos[i].hashCode() + "");
					cpuInfo.setCacheSize(infos[i].getCacheSize());
					cpuInfo.setModel(infos[i].getModel());
					cpuInfo.setUsed(CpuPerc.format(perc.getCombined()));
					cpuInfo.setUsedOrigVal(perc.getCombined());
					cpuInfo.setIdle(CpuPerc.format(perc.getIdle()));
					cpuInfo.setTotalMHz(infos[i].getMhz());
					cpuInfo.setVendor(infos[i].getVendor());
					status.getCpuInfos().add(cpuInfo);
					totalUse += perc.getCombined();
				}
				String cpuu = CpuPerc.format(totalUse / status.getCpuInfos().size());
				cpuu = cpuu.substring(0,cpuu.length()-1);
				status.setCpuUsage(cpuu);
			} catch (Exception e) {
				e.printStackTrace();
				status.setCpuUsage("无法获取服务器Cpu信息!");
			}
		}
		public static void findServerDiskInfo(Sigar sigar, ServerStatus status) {
			try {
				FileSystem fslist[] = sigar.getFileSystemList();
				FileSystemUsage usage = null;
				for (int i = 0; i < fslist.length; i++) {
					FileSystem fs = fslist[i];
					switch (fs.getType()) {
					case 0: // TYPE_UNKNOWN ：未知
					case 1: // TYPE_NONE
					case 3:// TYPE_NETWORK ：网络
					case 4:// TYPE_RAM_DISK ：闪存
					case 5:// TYPE_CDROM ：光驱
					case 6:// TYPE_SWAP ：页面交换
						break;
					case 2: // TYPE_LOCAL_DISK : 本地硬盘
						DiskInfos disk = new DiskInfos();
						disk.setDevName(fs.getDevName());
						disk.setDirName(fs.getDirName());
						usage = sigar.getFileSystemUsage(fs.getDirName());
						disk.setTotalSize(usage.getTotal() / (1024 * 1024));
						// disk.setFreeSize(usage.getFree()/(1024*1024));
						disk.setAvailSize(usage.getAvail() / (1024 * 1024));
						disk.setUsedSize(usage.getUsed() / (1024 * 1024));
						disk.setUsePercent(usage.getUsePercent() * 100D + "%");
						disk.setTypeName(fs.getTypeName());
						disk.setSysTypeName(fs.getSysTypeName());

						status.getDiskInfos().add(disk);

					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		public static void findServerMemoryInfo(Sigar sigar, ServerStatus status) {
			try {
				Mem mem = sigar.getMem();
				status.setTotalMem(mem.getTotal() / (1024 * 1024));
				status.setUsedMem(mem.getUsed() / (1024 * 1024));
				status.setFreeMem(mem.getFree() / (1024 * 1024));
				// 交换区
				Swap swap = sigar.getSwap();
				status.setTotalSwap(swap.getTotal() / (1024 * 1024));
				status.setUsedSwap(swap.getUsed() / (1024 * 1024));
				status.setFreeSwap(swap.getFree() / (1024 * 1024));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	
	public String getJavaServer() {
		return javaServer;
	}

	public void setJavaServer(String javaServer) {
		this.javaServer = javaServer;
	}

	public String getDeployPath() {
		return deployPath;
	}

	public void setDeployPath(String deployPath) {
		this.deployPath = deployPath;
	}

	public String getServerTime() {
		return serverTime;
	}

	public void setServerTime(String serverTime) {
		this.serverTime = serverTime;
	}

	public String getServerName() {
		return serverName;
	}

	public void setServerName(String serverName) {
		this.serverName = serverName;
	}

	public String getServerOs() {
		return serverOs;
	}

	public void setServerOs(String serverOs) {
		this.serverOs = serverOs;
	}

	public String getJavaHome() {
		return javaHome;
	}

	public void setJavaHome(String javaHome) {
		this.javaHome = javaHome;
	}

	public String getJavaVersion() {
		return javaVersion;
	}

	public void setJavaVersion(String javaVersion) {
		this.javaVersion = javaVersion;
	}

	public long getJvmTotalMem() {
		return jvmTotalMem;
	}

	public void setJvmTotalMem(long jvmTotalMem) {
		this.jvmTotalMem = jvmTotalMem;
	}

	public long getJvmFreeMem() {
		return jvmFreeMem;
	}

	public void setJvmFreeMem(long jvmFreeMem) {
		this.jvmFreeMem = jvmFreeMem;
	}


	public long getTotalMem() {
		return totalMem;
	}
	
	public String getJavaTmpPath() {
		return javaTmpPath;
	}

	public void setJavaTmpPath(String javaTmpPath) {
		this.javaTmpPath = javaTmpPath;
	}

	public void setTotalMem(long totalMem) {
		this.totalMem = totalMem;
	}

	public long getUsedMem() {
		return usedMem;
	}

	public void setUsedMem(long usedMem) {
		this.usedMem = usedMem;
	}

	public long getFreeMem() {
		return freeMem;
	}

	public void setFreeMem(long freeMem) {
		this.freeMem = freeMem;
	}

	public long getTotalSwap() {
		return totalSwap;
	}

	public void setTotalSwap(long totalSwap) {
		this.totalSwap = totalSwap;
	}

	public long getUsedSwap() {
		return usedSwap;
	}

	public void setUsedSwap(long usedSwap) {
		this.usedSwap = usedSwap;
	}

	public long getFreeSwap() {
		return freeSwap;
	}

	public void setFreeSwap(long freeSwap) {
		this.freeSwap = freeSwap;
	}

	public List<CpuInfos> getCpuInfos() {
		return cpuInfos;
	}

	public void setCpuInfos(List<CpuInfos> cpuInfos) {
		this.cpuInfos = cpuInfos;
	}

	public List<DiskInfos> getDiskInfos() {
		return diskInfos;
	}

	public void setDiskInfos(List<DiskInfos> diskInfos) {
		this.diskInfos = diskInfos;
	}

	public boolean isSigarInitError() {
		return sigarInitError;
	}

	public void setSigarInitError(boolean sigarInitError) {
		this.sigarInitError = sigarInitError;
	}
	

	public String getCpuUsage() {
		return cpuUsage;
	}

	public void setCpuUsage(String cpuUsage) {
		this.cpuUsage = cpuUsage;
	}
	
	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public long getJvmMaxMem() {
		return jvmMaxMem;
	}

	public void setJvmMaxMem(long jvmMaxMem) {
		this.jvmMaxMem = jvmMaxMem;
	}
}
